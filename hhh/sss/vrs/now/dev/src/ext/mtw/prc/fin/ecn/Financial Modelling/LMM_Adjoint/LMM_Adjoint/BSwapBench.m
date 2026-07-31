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
warning off;
clc;

import IRD.*;

B = BSwap;

perf = zeros(9,5);

paths = 10;
m(1)=10;
m(2)=20;
m(3)=50;
m(4)=75;
m(5)=100;

for i=1:5
    m(i)
    tstart = tic;
    B.m = m(i);

    B.tau = 0.5;
    B.L = 0.035;
    B.sigma = 0.2;
    B.paths = paths;
    B.epsilon = 0.001;
    B.msg = 0;
    B.frozen = 1;

    B.e = 2;
    B.K = 0.03;
    B.phi = 1;
    B.nom = 10000;
    B.d = 3;

    B = B.Initialize;
    B = B.MonteCarlo;
    B = B.LMM_Simulation;
    B = B.LSM_Simulation;
    tini=toc(tstart);

    B.msg = 1;
    Deltafor = B.CalcDelta('for');
    Deltaadj = B.CalcDelta('adj');
    Deltaads = B.CalcDelta('ads');
    % DeltaFD = B.CalcDelta('FD');

    % [Deltafor.' Deltaadj.' Deltaads.']
    % 
    Gammafor = B.CalcGamma('for');
    Gammaadj = B.CalcGamma('adj');
    Gammaads = B.CalcGamma('ads');
    %GammaFD = B.CalcGamma('FD');

    Vegafor = B.CalcVega('for');
    Vegaadj = B.CalcVega('adj');
    Vegaads = B.CalcVega('ads');
    %VegaFD = B.CalcVega('FD'); 
end
