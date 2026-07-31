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

%_________________ Input Parameter
maturity = 1/5;          % options time to maturity
nHedgeSimulations = 1;                                                   
nReHedges = 50;        % # of rehedges
start = 1;             % first hedge
spotPrice = 7000;
rate = 0.03;
%------------------ Pricer Selection
pricer.ID = 'Cosine';   % Cosine, Carr, Lewis, Conv, BlackScholes
pricer.N = 2^12;
pricer.L = 20;
pricer.eta = 0.1;
pricer.PriceAndGreeks = PricerFactory(pricer);
%------------------ Model and Data Selection
model.ID = 'NIG';            % BlackScholes, NIG, Bates, Heston, VarianceGamma
model.params(1) = 3.14;
model.params(2) = -2.04;
model.params(3) = 0.13;
model.PathSimulator = SimulatorFactory(model);
%__________________ Hedges 
hedgeCostsMV = HedgeSimMV(spotPrice, maturity, nReHedges, nHedgeSimulations, ...
                          rate, model, pricer);
%__________________ Output
figure; hist(hedgeCostsMV.lossProcess,20); title('Loss Distribution MV Hedge');