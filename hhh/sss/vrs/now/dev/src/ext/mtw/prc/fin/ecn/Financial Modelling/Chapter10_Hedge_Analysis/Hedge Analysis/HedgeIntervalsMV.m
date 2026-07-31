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



function hedgeCostsDelta = HedgeIntervalsMV(maturityInDays, ...
                                                   nHedges, ...
                                                   start, ...
                                                   data, ...
                                                   model, ...
                                                   pricer)

% Routine simulates several option hedge strategies on a given asset path.
% On the given path every day a new option with constant tenor is initialised.
% To hedge the option until its maturity date an asset path is simulated with 
% the market data as start parameters.   

% --- Factories
%VolaParas = VolaFactory(model,data,levyData);
%PriceAndGreeks = PricerFactory(pricer);
% --- renaming input parameters
n = maturityInDays;
m = nHedges;
d = 0.0;
% --- initialise variables
% hedge option
mvHedge = zeros(n,1,m);
% hedge portfolio
bankAccount = zeros(n,1,m);
gainProcess = zeros(n,1,m);
valueProcess = zeros(n,1,m);
lossProcess = zeros(1,m);
cumGains = zeros(n,1,m);
% asset 
stockPath = zeros(n,1);

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
    valueProcess(i,1,j-start+1) = pricer.PriceAndGreeks(model,stockPath(i,1),strikePrice,cT,rate,d);
    mvHedge(i,1,j-start+1) = MeanVarianceParameter(model,pricer,stockPath(i,1),strikePrice,rate,0,cT);
    %--- Hedgeparameter Portfoliohedge
    HedgeParameterMV(i,j-start+1)
    for i = 2:n     % Loop within one hedge
        %--- Original Option Value and Hedge Parameters
        ttm = cT-(i-1)*dt;  % time to maturity
        rate = data.spotRates(j-1+i,ttm);
        model.params = data.VolaParas(j-1+i,stockPath(i,1),strikePrice,ttm);
        valueProcess(i,1,j-start+1) = pricer.PriceAndGreeks(model,stockPath(i,1),strikePrice,ttm,rate,d);
        mvHedge(i,1,j-start+1) = MeanVarianceParameter(model,pricer,stockPath(i,1),strikePrice,rate,0,ttm);
        %--- Hedgeparameter Portfoliohedge
        HedgeParameterMV(i,j-start+1)
        %--- Gain and Loss-Process Portfoliohedge
        spotRate = data.spotRates(j-1+i,dt);
        HedgePortfolioMV(spotRate,i,j-start+1)
    end
end

%---- Output
% Delta Hedge
hedgeCostsDelta.stockPath = stockPath(:,1);
hedgeCostsDelta.valueProcess = valueProcess(:,1,:);
hedgeCostsDelta.bankAccount = bankAccount(:,1,:);
hedgeCostsDelta.gainProcess = gainProcess(:,1,:);
hedgeCostsDelta.lossProcess = lossProcess(1,:);
hedgeCostsDelta.mvParameter = mvHedge(:,1,:);


%---- Private Functions

function  HedgeParameterMV(i,j)

bankAccount(i,1,j) = (valueProcess(i,1,j) - stockPath(i,1) * mvHedge(i,1,j));
end

function HedgePortfolioMV(spotRate,i,j)

gainProcess(i,1,j) = mvHedge(i-1,1,j)*(stockPath(i,1)-stockPath(i-1,1)) + bankAccount(i-1,1,j)*(exp(spotRate*dt)-1);
cumGains(i,1,j) = cumGains(i-1,1,j) + gainProcess(i,1,j);
lossProcess(1,j) = valueProcess(i,1,j) - valueProcess(1,1,j)- cumGains(i,1,j);

end

end