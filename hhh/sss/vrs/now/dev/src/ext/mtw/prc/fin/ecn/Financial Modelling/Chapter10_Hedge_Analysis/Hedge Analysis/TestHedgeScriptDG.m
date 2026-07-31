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



clear; clc;
currentpath = pwd;

File1 = 'DAX Bloomi.xls';
File2 = 'DAXresults.xls';
File1 = [currentpath,'\',File1];
File2 = [currentpath,'\',File2];

%_________________ Input Parameter
n = 50;                 % # of business days in options time to maturity
m = 13;                % # of hedges 1435
tm = 1.5;               % maturity multiplier (gamma hedge)
sm = 1;                 % strike multiplier (gamma hedge)
start = 1;              % first hedge
%------------------ Pricer Selection
pricer.ID = 'BlackScholes';   % BlackScholes, Cosine, Carr, Lewis, Conv
pricer.N = 2^12;
pricer.L = 40;
pricer.eta = 0.1;
pricer.PriceAndGreeks = PricerFactory(pricer);
%------------------ Model and Data Selection
model.ID = 'Heston';            % BlackScholes, NIG, Bates, Heston, VarianceGamma
data = DAXDataBloomi(model,File1);          % read DAX Data incl. Volacube and Zerorates
levyData = DAXLevyBloomi(model,File2);      % read Levy Parameters calibrated to DAX data
data.VolaParas = VolaFactory(model,data,levyData);
data.spotRates = @(i,maturity)interp1(data.interestMaturities,data.interestRates(:,i),maturity,'spline');
%__________________ Hedges 
[hedgeCostsBS50, hedgeCostsGammaBS50] = HedgeIntervalsDG(n, m, tm, sm, start, data, model, pricer);
%__________________ Output
figure; hist(hedgeCostsBS50.lossProcess,20); title('Loss Distribution Delta Hedge, t = 50');
figure; hist(hedgeCostsGammaBS50.lossProcess,20); title('Loss Distribution Delta Gamma Hedge, t = 50');