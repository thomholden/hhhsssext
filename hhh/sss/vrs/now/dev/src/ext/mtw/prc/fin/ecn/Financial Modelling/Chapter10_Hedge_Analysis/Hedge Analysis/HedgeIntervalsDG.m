% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [hedgeCostsDelta, hedgeCostsDeltaGamma] = HedgeIntervalsDG(maturityInDays, ...
                                                   nHedges, gammaMaturityMultiplier, ...
                                                   gammaStrikeMultiplier, start, data, ...
                                                   model, pricer)

% Routine simulates several option hedge strategies on a given asset path.
% On the given path every day a new option with constant tenor is initialised.
% To hedge the option until its maturity date an asset path is simulated with 
% the market data as start parameters.   

% --- renaming input parameters
    n = maturityInDays;
    m = nHedges;
    d = 0.0;
% --- initialise variables
% hedge options - 1 is for the option, 2 is for the gamma option
    deltaHedge = zeros(n,2,m);
    gammaHedge = zeros(n,2,m);
    nUnderlying = zeros(n,1,m);
    nOption = zeros(n,1,m);
% hedge portfolio - 1 is for delta, 2 is for delta/gamma
    bankAccount = zeros(n,2,m);
    gainProcess = zeros(n,2,m);
    valueProcess = zeros(n,2,m);
    lossProcess = zeros(2,m);
    cumGains = zeros(n,2,m);
% asset - 1 is for the option, 2 is for the gamma option
    stockPath = zeros(n,1);
    selector = zeros(1,m);

% --- hedge procedure
for j=start:start+m-1       % Loop over m hedges
        i = 1;
    %--- Start Parameter Original Option
        cT = (data.stockDates(j+ n)-data.stockDates(j))/365;     % option 1 time to maturity p.a.
        dt = cT/(n);                                              % time steps
        rate = data.spotRates(j,cT);
        stockPath(:,1) = data.stockPrices(j:j+n-1);   % select stock prices within hedgerange
        strikePrice = stockPath(1,1);
    %--- Original Option Value and Hedge Parameters
        model.params = data.VolaParas(j,strikePrice,strikePrice,cT);
        [valueProcess(i,1,j-start+1),deltaHedge(i,1,j-start+1),gammaHedge(i,1,j-start+1)] = pricer.PriceAndGreeks(model,stockPath(i,1),strikePrice,cT,rate,d);
        if stockPath(i,1)/strikePrice > 1.15 || stockPath(i,1)/strikePrice < 0.85
            selector(1,j-start+1) = 1;
        end
    %--- Start Parameter Additional Option
        optionMaturity = cT * gammaMaturityMultiplier;
        rateOption = data.spotRates(j,optionMaturity);
        strikePriceOption = strikePrice * gammaStrikeMultiplier;
    %--- Additional Option Value and Hedge Parameter    
        model.params = data.VolaParas(j,strikePrice,strikePrice,optionMaturity);
        [valueProcess(i,2,j-start+1),deltaHedge(i,2,j-start+1),gammaHedge(i,2,j-start+1)] = pricer.PriceAndGreeks(model,stockPath(i,1),strikePriceOption,optionMaturity,rateOption,d);
    %--- Hedgeparameter Portfoliohedge
        HedgeParameterDelta(i,j-start+1)
        HedgeParameterDeltaGamma(i,j-start+1)
    for i = 2:n     % Loop within one hedge
        %--- Original Option Value and Hedge Parameters
            ttm = cT-(i-1)*dt;  % time to maturity
            rate = data.spotRates(j-1+i,ttm);
            model.params = data.VolaParas(j-1+i,stockPath(i,1),strikePrice,ttm);
            [valueProcess(i,1,j-start+1),deltaHedge(i,1,j-start+1),gammaHedge(i,1,j-start+1)] = pricer.PriceAndGreeks(model,stockPath(i,1),strikePrice,ttm,rate,d);
            if stockPath(i,1)/strikePrice > 1.15 || stockPath(i,1)/strikePrice < 0.85
                selector(1,j-start+1) = 1;
            end
        %--- Additional Option Value and Hedge Parameters
            ttmOption = optionMaturity-(i-1)*dt;  % time to maturity
            rateOption = data.spotRates(j-1+i,ttmOption);
            model.params = data.VolaParas(j-1+i,stockPath(i,1),strikePrice,ttmOption); 
            [valueProcess(i,2,j-start+1),deltaHedge(i,2,j-start+1),gammaHedge(i,2,j-start+1)] = pricer.PriceAndGreeks(model,stockPath(i,1),strikePriceOption,ttmOption,rateOption,d);
        %--- Hedgeparameter Portfoliohedge
            HedgeParameterDelta(i,j-start+1)
            HedgeParameterDeltaGamma(i,j-start+1)
        %--- Gain and Loss-Process Portfoliohedge
            spotRate = data.spotRates(j-1+i,dt);
            HedgePortfolioDelta(spotRate,i,j-start+1)
            HedgePortfolioDeltaGamma(spotRate,i,j-start+1)
    end
end

%---- Output
% Delta Hedge
hedgeCostsDelta.stockPath = stockPath(:,1);
hedgeCostsDelta.valueProcess = valueProcess(:,1,:);
hedgeCostsDelta.bankAccount = bankAccount(:,1,:);
hedgeCostsDelta.gainProcess = gainProcess(:,1,:);
hedgeCostsDelta.lossProcess = lossProcess(1,:);
hedgeCostsDelta.deltaParameter = deltaHedge(:,1,:);
hedgeCostsDelta.boundedPaths = selector;
% Delta-Gamma Hedge
hedgeCostsDeltaGamma.stockPath = stockPath(:,1);
hedgeCostsDeltaGamma.valueProcess = valueProcess;
hedgeCostsDeltaGamma.bankAccount = bankAccount(:,2,:);
hedgeCostsDeltaGamma.gainProcess = gainProcess(:,2,:);
hedgeCostsDeltaGamma.lossProcess = lossProcess(2,:);
hedgeCostsDeltaGamma.deltaParameter = deltaHedge;
hedgeCostsDeltaGamma.gammaParameter = gammaHedge;
hedgeCostsDeltaGamma.nOption = nOption;
hedgeCostsDeltaGamma.nUnderlying = nUnderlying;


%---- Private Functions

function  HedgeParameterDelta(i,j)

bankAccount(i,1,j) = (valueProcess(i,1,j) - stockPath(i,1) * deltaHedge(i,1,j));
end

function HedgePortfolioDelta(spotRate,i,j)

gainProcess(i,1,j) = deltaHedge(i-1,1,j)*(stockPath(i,1)-stockPath(i-1,1)) + bankAccount(i-1,1,j)*(exp(spotRate*dt)-1);
cumGains(i,1,j) = cumGains(i-1,1,j) + gainProcess(i,1,j);
lossProcess(1,j) = valueProcess(i,1,j) - valueProcess(1,1,j)- cumGains(i,1,j);

end

function  HedgeParameterDeltaGamma(i,j)

nOption(i,1,j) = (gammaHedge(i,1,j)/gammaHedge(i,2,j));
% if nOption(i,1,j) > 3
%     nOption(i,1,j) = 3;
% elseif nOption(i,1,j) < 0
%     nOption(i,1,j) = 0.7;
% end
nUnderlying(i,1,j) = deltaHedge(i,1,j) - deltaHedge(i,2,j) * nOption(i,1,j);
bankAccount(i,2,j) = (valueProcess(i,1,j) - nUnderlying(i,1,j) *...
                   stockPath(i,1) - nOption(i,1,j)* valueProcess(i,2,j));
end

function HedgePortfolioDeltaGamma(spotRate,i,j)

gainProcess(i,2,j) = nUnderlying(i-1,1,j)*(stockPath(i,1) - stockPath(i-1,1)) + ...
                   nOption(i-1,1,j) *(valueProcess(i,2,j)- valueProcess(i-1,2,j)) + ...
                   bankAccount(i-1,2,j)*(exp(spotRate*dt)-1);
cumGains(i,2,j) = cumGains(i-1,2,j) + gainProcess(i,2,j);
lossProcess(2,j) = valueProcess(i,1,j) - valueProcess(1,1,j)- ...
                   cumGains(i,2,j);

end

end