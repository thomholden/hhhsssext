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
maturity = 0.5;          % options time to maturity
nHedgeSimulations = 10;                                                   
nReHedges = 125;        % # of rehedges
gammaMaturityMultiplier = 1.5;            % maturity multiplier (gamma hedge)
gammaStrikeMultiplier = 1;                 % strike multiplier (gamma hedge)
start = 1;              % first hedge
spotPrice = 100;
rate = 0.03;
%------------------ Pricer Selection
pricer.ID = 'Conv';   % Cosine, Carr, Lewis, Conv, BlackScholes
pricer.N = 2^12;
pricer.L = 20;
pricer.eta = 0.1;
pricer.PriceAndGreeks = PricerFactory(pricer);

% %__________________ Hedges 
%------------------ Model and Data Selection BS
% model.ID = 'BlackScholes';            % BlackScholes, NIG, Bates, Heston, VarianceGamma
% model.params(1) = 0.2413;
% model.PathSimulator = SimulatorFactory(model);
% [hedgeCostsDelta, hedgeCostsDeltaGammaB] = HedgeSim(spotPrice, maturity, nReHedges, ...
%                                                    nHedgeSimulations, gammaMaturityMultiplier, ...
%                                                    gammaStrikeMultiplier, rate, model, pricer);
% 
%------------------ Model and Data Selection NIG
model.ID = 'NIG';            % BlackScholes, NIG, Bates, Heston, VarianceGamma
model.params(1) = 3.1128;
model.params(2) = -2.1093;
model.params(3) = 8; %0.1215;
model.PathSimulator = SimulatorFactory(model);
%__________________ Hedges 
[hedgeCostsDelta, hedgeCostsDeltaGamma] = HedgeSim(spotPrice, maturity, nReHedges, ...
                                                   nHedgeSimulations, gammaMaturityMultiplier, ...
                                                   gammaStrikeMultiplier, rate, model, pricer);
% 
% %------------------ Model and Data Selection VG
% model.ID = 'VarianceGamma';            % BlackScholes, NIG, Bates, Heston, VarianceGamma
% model.params(1) = 0.3523;
% model.params(2) = 2.2476;
% model.params(3) = 5.3235;
% model.PathSimulator = SimulatorFactory(model);
% %__________________ Hedges 
% [hedgeCostsDelta, hedgeCostsDeltaGamma] = HedgeSim(spotPrice, maturity, nReHedges, ...
%                                                    nHedgeSimulations, gammaMaturityMultiplier, ...
%                                                    gammaStrikeMultiplier, rate, model, pricer);   
%                                                
% %------------------ Model and Data Selection Heston
% model.ID = 'Heston';            % BlackScholes, NIG, Bates, Heston, VarianceGamma
% model.params(1) = 0.0396;
% model.params(2) = 0.0900;
% model.params(3) = 0.6165;
% model.params(4) = 0.4274;
% model.params(5) = -0.6950;
% model.PathSimulator = SimulatorFactory(model);
% %__________________ Hedges 
% [hedgeCostsDelta hedgeCostsDeltaGamma] = HedgeSim(spotPrice, maturity, nReHedges, ...
%                                                    nHedgeSimulations, gammaMaturityMultiplier, ...
%                                                    gammaStrikeMultiplier, rate, model, pricer);                                               

%------------------ Model and Data Selection Bates
% model.ID = 'Bates';            % BlackScholes, NIG, Bates, Heston, VarianceGamma
% model.params(1) = 0.04;
% model.params(2) = 0.04;
% model.params(3) = 0.2;
% model.params(4) = 0.1;
% model.params(5) = 0;
% model.params(6) = 0.2;
% model.params(7) = 0.25;
% model.params(8) = 0.2;
% model.PathSimulator = SimulatorFactory(model);
% %__________________ Hedges 
% [hedgeCostsDelta, hedgeCostsDeltaGamma] = HedgeSim(spotPrice, maturity, nReHedges, ...
%                                                    nHedgeSimulations, gammaMaturityMultiplier, ...
%                                                    gammaStrikeMultiplier, rate, model, pricer);
%                                                
%__________________ Output
figure; hist(hedgeCostsDelta.lossProcess,20); title('Loss Distribution Delta Hedge');
figure; hist(hedgeCostsDeltaGamma.lossProcess,20); title('Loss Distribution Delta-Gamma Hedge');

