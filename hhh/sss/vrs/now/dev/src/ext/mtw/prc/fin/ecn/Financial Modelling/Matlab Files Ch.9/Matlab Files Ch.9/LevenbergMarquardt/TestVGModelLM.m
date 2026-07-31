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
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 


% This script demonstrates the calibration of the VG-Model by use of the 
% Levenberg-Marquardt optimization algorithm.
% Function SMARQUARDT of the IMMOPTIBOX toolbox is available from:
% http://www2.imm.dtu.dk/~hbn/immoptibox/

p = path;
addpath(genpath(pwd));

% Example 5: VG-Model Calibration FFT Prices
%----------------------------------------------------------------------
% fft struct
fftStruct = struct('pricer',@LewisCallPricingFFT, 'N',2^12, 'eta',0.05);
% option struct
option.S = 100;
option.K = (80:5:120)';
option.r = 0.02;
option.d = 0.01;
option.T = [1; 3; 5];
% model struct
model.ID = 'VarianceGamma';
model.params = [0.125;0.375;0.2]; %sigma,nu,theta
% market prices
PM = fftpricer(model,fftStruct,option);

% initialize optimization procedure
%---------------------------------------------------------------------
% objective function
fun = @residualPriceFFT;
% initial guess
x0  = [0.3 0.7 0.5]';

% Algorithmic Paramters
maxeval = 200;	% maximum number of iterations
tolg     = 1e-9;	% convergence tolerance for gradient
tolx     = 1e-12;	% convergence tolerance for parameters
tau     = 1e-3;	% determines acceptance of a L-M step

% options
opts.tau = tau;
opts.tolg = tolg;
opts.tolx = tolx;
opts.maxeval = maxeval;

% start calibration
[X,info,perf] = smarquardt(fun,x0,opts,[],PM,fftStruct,option,model.ID)

path(p)