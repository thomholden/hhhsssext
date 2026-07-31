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



function hedgeCostsMV = HedgeSimMV(spotPrice, ...
                        maturity, ...
                        nReHedges, ...
                        nHedgeSimulations, ...
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
% hedge option
    MVHedge = zeros(n,1,m);
% hedge portfolio
    bankAccount = zeros(n,1,m);
    gainProcess = zeros(n,1,m);
    valueProcess = zeros(n,1,m);
    lossProcess = zeros(1,m);
    cumGains = zeros(n,1,m);
% asset
    stockPath = model.PathSimulator(spotPrice,T,n,m,0.05);   % select stock prices within hedgerange
% --- hedge procedure
for j=1:m       % Loop over m hedges
        i = 1;
    %--- Start Parameter Original Option
        strikePrice = spotPrice;
    %--- Original Option Value and Hedge Parameters
        valueProcess(i,1,j) = pricer.PriceAndGreeks(model,stockPath(i,j),strikePrice,T,rate,d);
        MVHedge(i,1,j) = MeanVarianceParameter(model,pricer,stockPath(i,j),strikePrice,rate,d,T);
    %--- Hedgeparameter Portfoliohedge
        HedgeParameter(i,j)
    for i = 2:n     % Loop within one hedge
        %--- Original Option Value and Hedge Parameters
            ttm = T-(i-1)*dt;  % time to maturity
            valueProcess(i,1,j)= pricer.PriceAndGreeks(model,stockPath(i,j),strikePrice,ttm,rate,d);
            MVHedge(i,1,j) = MeanVarianceParameter(model,pricer,stockPath(i,j),strikePrice,rate,d,ttm);
        %--- Hedgeparameter Portfoliohedge
            HedgeParameter(i,j)
        %--- Gain and Loss-Process Portfoliohedge
            HedgePortfolio(rate,i,j,dt)
    end
end

%---- Output
% Delta Hedge
%hedgeCostsMV.stockPath = stockPath;
%hedgeCostsMV.valueProcess = valueProcess(:,1,:);
%hedgeCostsMV.bankAccount = bankAccount(:,1,:);
%hedgeCostsMV.gainProcess = gainProcess(:,1,:);
hedgeCostsMV.lossProcess = lossProcess(1,:);
hedgeCostsMV.MVParameter = MVHedge(:,1,:);

%---- Private Functions

function  HedgeParameter(i,j)
    
bankAccount(i,1,j) = (valueProcess(i,1,j) - stockPath(i,j) * MVHedge(i,1,j));
end

function HedgePortfolio(spotRate,i,j,dt)

gainProcess(i,1,j) = MVHedge(i-1,1,j)*(stockPath(i,j)-stockPath(i-1,j)) + bankAccount(i-1,1,j)*(exp(spotRate*dt)-1);
cumGains(i,1,j) = cumGains(i-1,1,j) + gainProcess(i,1,j);
lossProcess(1,j) = valueProcess(i,1,j) - valueProcess(1,1,j)- cumGains(i,1,j);

end

end