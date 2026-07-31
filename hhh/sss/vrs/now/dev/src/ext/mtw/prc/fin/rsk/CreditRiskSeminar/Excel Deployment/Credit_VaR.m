function [OriginalPrices, OriginalPortfolioValue, VaRMatrix] = ...
    Credit_VaR( ...
        TransitionMatrix, ...
        RecoveryRates, ...
        BondData, ...
        Rates, ...
        CorrelationMatrix, ...
        CorrelationAlpha, ...
        numScenarios, ...
        valDate, ...
        PercentForVaR)
%% 1. Load data

TransitionMatrix  = cell2dataset( ...
    TransitionMatrix, ...
    'ReadObsNames', true, ...
    'ReadVarNames', true);
% This will prove useful:
Ratings = get(TransitionMatrix, 'VarNames');

RecoveryRates = cell2dataset( ...
    RecoveryRates, ...
    'ReadObsNames', true, ...
    'ReadVarNames', true);

BondData = cell2dataset( ...
    BondData, ...
    'ReadVarNames', true,...
    'DataTypes', {'double', 'date', 'double',...
    'nominal', 'double', 'double', 'nominal'});
                        
Rates = cell2dataset( ...
    Rates, ...
    'ReadObsNames', true, ...
    'ReadVarNames', true);

ctrans = CorrelationMatrix';
tempMask = isnan(CorrelationMatrix) | CorrelationMatrix == 0;
CorrelationMatrix(tempMask) = ctrans(tempMask);
clear ctrans tempMask

valDate = x2mdate(valDate);

PercentForVaR = 100 * PercentForVaR;

numAssets = size(BondData,1);

%% 2. Compute original value of portfolio
OriginalPrices = zeros(size(BondData, 1), 1);
dates = [valDate; valDate+365; valDate+2*365; valDate+3*365];

% The |prbyzero| function in the Financial Toolbox allows us to value
% these bonds.
for idx = 1 : length(Ratings)-1
    ratingsMask = BondData.Rating == Ratings{idx};
    OriginalPrices(ratingsMask) = prbyzero( ...
        [BondData.Maturity(ratingsMask) BondData.Coupon(ratingsMask)],...
        valDate, Rates.(Ratings{idx}), dates);
end

OriginalPortfolioValue = OriginalPrices' * BondData.NumberOfBonds;

%% 3. Compute ratings thresholds
% These represent the number of standard deviations an asset price has to
% move before the parent company suffers a rating change.

% Cumulatively add the transition probabilities, starting at the lower end.
ThresholdMatrix = fliplr(cumsum(fliplr(double(TransitionMatrix)), 2));
% Turn these into thresholds.
ThresholdMatrix = norminv(ThresholdMatrix);
% Convert into a dataset array with a similar format as |TransitionMatrix|.
ThresholdMatrix = replacedata(TransitionMatrix, ThresholdMatrix); 

%% 4. Generate scenarios

IndustryRandom = mvnrnd( ...
    zeros(size(CorrelationMatrix, 1), 1), ...
    CorrelationMatrix, ...
    numScenarios)';

BondRandom = CorrelationAlpha*IndustryRandom(BondData.Industry,:) + ...
    sqrt(1-CorrelationAlpha.^2)*randn(numAssets,numScenarios);

%% 5. Find rating of each bond at the end of the simulations
NewRatings = ones(numAssets,numScenarios);

for i = 1 : numAssets
    FirmRating = BondData.Rating(i);
    Thresholds = [double(ThresholdMatrix(char(FirmRating),:)) -Inf];
    for j=2:numel(Thresholds)
        RatingMask = BondRandom(i,:) > Thresholds(j) & BondRandom(i,:) < Thresholds(j-1);
        NewRatings(i,RatingMask) = j-1;
    end
end

clear BondRandom

NewRatings = ordinal(NewRatings, Ratings);

%% 6. Value bonds based on the simulated ratings
% Pre-calculate the non-default prices.
NondefaultPrices = prbyzero([BondData.Maturity BondData.Coupon], ...
    valDate, double(Rates), dates);

NewPrices = zeros(numAssets,numScenarios);

for Bond = 1 : numAssets
    for idx = 1 : length(Ratings)
        % Consider nondefault cases:
        if idx <= 7; % TODO: better value here
            ratingsMask = NewRatings(Bond,:) == Ratings{idx};
            NewPrices(Bond,ratingsMask) = NondefaultPrices(Bond,idx);
        % Consider default cases:
        else
            Seniority = char(BondData{Bond,'Seniority'});
            DistribParameters = double(RecoveryRates(Seniority,{'Mean','STD'}));
            defaultMask = NewRatings(Bond,:) == 'Default';
            NbToDraw = sum(defaultMask);
            NewPrices(Bond, defaultMask) = ...
                100 * betarndms(DistribParameters(1),DistribParameters(2),...
                1,NbToDraw);
        end
    end
end

%% 7. Compute values of simulated portfolios
NewPrices = bsxfun(@times, NewPrices, BondData.NumberOfBonds);
NewPortfolioValues = sum(NewPrices,1);

%% 8. Output the distribution of simulated values for the portfolio

Losses = OriginalPortfolioValue - NewPortfolioValues;

VaR = prctile(Losses, PercentForVaR);
relativeVaR = VaR / OriginalPortfolioValue;

CVaR = zeros(size(VaR));

for i = 1:length(PercentForVaR)
    CVaR(i) = mean(Losses(Losses >= VaR(i)));
end

relativeCVaR = CVaR / OriginalPortfolioValue;

VaRMatrix = [VaR relativeVaR CVaR relativeCVaR];
    
if isdeployed
    figure('Visible', 'off'); 
else
    figure,
end

set(gcf,'Position',[100 100 800 350])
hold on
hist(Losses,100);
l1 = plot([VaR(2) VaR(2)], ylim, 'b', 'LineWidth', 2);
l2 = plot([CVaR(2) CVaR(2)], ylim, 'r', 'LineWidth', 2);
set(gca, 'FontSize', 16, 'FontName', 'Calibri', ...
    'YTickLabel','')
xlabel('Losses (in USD)')
legend([l1 l2], ...
    [int2str(PercentForVaR(2)) '% VaR: ' cur2str(VaR(2),0)], ...
    [int2str(PercentForVaR(2)) '% CVaR: ' cur2str(CVaR(2),0)])
hold off

if isdeployed
    print -dmeta
    close(gcf)
end