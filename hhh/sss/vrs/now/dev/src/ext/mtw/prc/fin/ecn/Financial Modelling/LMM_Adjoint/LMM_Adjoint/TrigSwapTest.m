% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Nikolai Nowaczyk
%   	    Joerg Kienitz
%           Daniel Wetterau
%           
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Nikolai Nowaczyk, Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



clear all;
clc;

import IRD.*;

TS = TrigSwap;

TS.m = 5;
TS.tau = 0.5;
TS.L = 0.035;
TS.sigma = 0.2;
TS.paths = 10000;
TS.msg = 1;
TS.epsilon = 0.001;

TS.e = 2;
TS.K = 0.05;
TS.s = 0.02;
TS.kappa = 0.035;
TS.N = 10000;

TS = TS.Initialize;
TS = TS.MonteCarlo;
TS = TS.LMM_Simulation;
TS = TS.CalcTriggered;
TS = TS.MCPayoff;
TS.Price;

% val = [0:1:100] / 1000;
% TS.DrawPlot(val,'K','Delta',[]);

profile clear
profile on

Deltafor = TS.CalcDelta('for');
Deltaadj = TS.CalcDelta('adj');
Deltaads = TS.CalcDelta('ads');
%DeltaFD = TS.CalcDelta('FD');


Gammafor = TS.CalcGamma('for');
Gammaadj = TS.CalcGamma('adj');
Gammaads = TS.CalcGamma('ads');
% GammaFD = TS.CalcGamma('FD');

Vegafor = TS.CalcVega('for');
Vegaadj = TS.CalcVega('adj');
Vegaads = TS.CalcVega('ads');
% VegaFD = TS.CalcVega('FD');

profile off
% p = profile('info');
% profview(0,p)