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



function [hedgeCostsDelta, hedgeCostsDeltaGamma] = HedgeSim(spotPrice, ...
                                                   maturity, ...
                                                   nReHedges, ...
                                                   nHedgeSimulations, ...
                                                   gammaMaturityMultiplier, ...
                                                   gammaStrikeMultiplier, ...
                                                   rate, ...
                                                   model, ...
                                                   pricer)

% Routine simulates several option hedge strategies with simulated asset paths.

% --- renaming input parameters
    T = maturity;
    n = nReHedges;
    m = nHedgeSimulations;
    d = 0.0;
    dt = T/n;
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
    stockPath = model.PathSimulator(spotPrice,T,n,m,0.05);   % select stock prices within hedgerange
% --- hedge procedure
for j=1:m       % Loop over m hedges
        i = 1;
    %--- Start Parameter Original Option
        strikePrice = spotPrice;
    %--- Original Option Value and Hedge Parameters
        [valueProcess(i,1,j),deltaHedge(i,1,j),gammaHedge(i,1,j)] = pricer.PriceAndGreeks(model,stockPath(i,j),strikePrice,T,rate,d);
    %--- Start Parameter Additional Option
        optionMaturity = T * gammaMaturityMultiplier;
        strikePriceOption = strikePrice * gammaStrikeMultiplier;
    %--- Additional Option Value and Hedge Parameter    
        [valueProcess(i,2,j),deltaHedge(i,2,j),gammaHedge(i,2,j)] = pricer.PriceAndGreeks(model,stockPath(i,j),strikePriceOption,optionMaturity,rate,d);
    %--- Hedgeparameter Portfoliohedge
        HedgeParameterDelta(i,j)
        HedgeParameterDeltaGamma(i,j)
    for i = 2:n     % Loop within one hedge
        %--- Original Option Value and Hedge Parameters
            ttm = T-(i-1)*dt;  % time to maturity
            [valueProcess(i,1,j),deltaHedge(i,1,j),gammaHedge(i,1,j)] = pricer.PriceAndGreeks(model,stockPath(i,j),strikePrice,ttm,rate,d);
        %--- Additional Option Value and Hedge Parameters
            ttmOption = optionMaturity-(i-1)*dt;  % time to maturity
            [valueProcess(i,2,j),deltaHedge(i,2,j),gammaHedge(i,2,j)] = pricer.PriceAndGreeks(model,stockPath(i,j),strikePriceOption,ttmOption,rate,d);
        %--- Hedgeparameter Portfoliohedge
            HedgeParameterDelta(i,j)
            HedgeParameterDeltaGamma(i,j)
        %--- Gain and Loss-Process Portfoliohedge
            HedgePortfolioDelta(rate,i,j,dt)
            HedgePortfolioDeltaGamma(rate,i,j,dt)
    end
end

%---- Output
% Delta Hedge
% hedgeCostsDelta.stockPath = stockPath;
% hedgeCostsDelta.valueProcess = valueProcess(:,1,:);
% hedgeCostsDelta.bankAccount = bankAccount(:,1,:);
% hedgeCostsDelta.gainProcess = gainProcess(:,1,:);
hedgeCostsDelta.lossProcess = lossProcess(1,:);
hedgeCostsDelta.deltaParameter = deltaHedge(:,1,:);
% Delta-Gamma Hedge
% hedgeCostsDeltaGamma.stockPath = stockPath;
% hedgeCostsDeltaGamma.valueProcess = valueProcess;
% hedgeCostsDeltaGamma.bankAccount = bankAccount(:,2,:);
% hedgeCostsDeltaGamma.gainProcess = gainProcess(:,2,:);
hedgeCostsDeltaGamma.lossProcess = lossProcess(2,:);
% hedgeCostsDeltaGamma.deltaParameter = deltaHedge;
% hedgeCostsDeltaGamma.gammaParameter = gammaHedge;
hedgeCostsDeltaGamma.nOption = nOption;
hedgeCostsDeltaGamma.nUnderlying = nUnderlying;


%---- Private Functions

function  HedgeParameterDelta(i,j)
    
bankAccount(i,1,j) = (valueProcess(i,1,j) - stockPath(i,j) * deltaHedge(i,1,j));
end

function HedgePortfolioDelta(spotRate,i,j,dt)

gainProcess(i,1,j) = deltaHedge(i-1,1,j)*(stockPath(i,j)-stockPath(i-1,j)) + bankAccount(i-1,1,j)*(exp(spotRate*dt)-1);
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
                   stockPath(i,j) - nOption(i,1,j)* valueProcess(i,2,j));
end

function HedgePortfolioDeltaGamma(spotRate,i,j,dt)

gainProcess(i,2,j) = nUnderlying(i-1,1,j)*(stockPath(i,j) - stockPath(i-1,j)) + ...
                   nOption(i-1,1,j) *(valueProcess(i,2,j)- valueProcess(i-1,2,j)) + ...
                   bankAccount(i-1,2,j)*(exp(spotRate*dt)-1);
cumGains(i,2,j) = cumGains(i-1,2,j) + gainProcess(i,2,j);
lossProcess(2,j) = valueProcess(i,1,j) - valueProcess(1,1,j)- ...
                   cumGains(i,2,j);

end

end