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




% This script demonstrates the performance of the SQP, DE, SA method
% on the basis of the Heston model calibration procedure

% Simulated Annealing(SA) -> Matlab Global Optimiaztion Toolbox
% Differential Evolution(DE) -> available from:
%       http://www1.icsi.berkeley.edu/~storn/code.html#matl

p = path;
addpath(genpath(pwd));

% % Load/Set state of the random number generator.
load rngStateNew
set(RandStream.getDefaultStream,'State',output.rngstate.state);


% fft struct
fftStruct = struct('pricer',@LewisCallPricingFFT, 'N',2^12, 'eta',0.05);
% option struct
option.S = 100;
option.K = (80:5:120)';
option.r = 0.02;
option.d = 0.01;
option.T = [1; 3; 5];
% model struct
model.ID = 'Heston';
model.params = [0.04;0.04;2.5;0.5;-0.8]; %vInst,vLong,kappa,omega,rho
% initial guess
x0  = [0.02 0.02 1 0.2 -0.3]';
% lower bounds
lb = [0 0 0 0 -1]';
% upper bounds
ub = [1 1 5 2 1]';

% market prices
PM = fftpricer(model,fftStruct,option);

% initialize optimization procedure
%---------------------------------------------------------------------
model.ID = 'Heston';
% objective function
fun = @(x)rmsefun(x,PM,fftStruct,option,model.ID);

% Algorithmic Paramters
maxeval = 200*length(x0);	% maximum number of iterations
tol     = 1e-8;	% convergence tolerance

% start calibration
[xMin,fMin,perfSQP] = modSQP(fun,x0,[],lb+tol,ub-tol,[],maxeval,tol)

% differential evolution
%-------------------------------------------------------------------
% population constants
    S_struct.I_D = 5; % number of parameters being optimized
    S_struct.I_NP = 50; % number of population members
    S_struct.FVr_minbound = lb'; % lower bounds
    S_struct.FVr_maxbound = ub'; % upper bounds
% use/don't use as bound constraints if set to 1/0
    S_struct.I_bnd_constr = 1;	
% termination criteria
    S_struct.F_VTR = fMin;  % value to reach
	S_struct.I_itermax = maxeval; % maximum number of iterations
% define DE strategy
	S_struct.I_strategy = 1;  % classical DE 
    S_struct.F_weight = 0.85; % mutation scaling factor
    S_struct.F_CR = 0.8;      % crossover probabililty
    
    S_struct.I_plotting = 0;
% after "I_refresh" iterations plot/print values
    S_struct.I_refresh = 20;

    S_struct.objfun = fun;

    
%---------Start optimization----------------------------------------
[FVr_x,S_y,I_nf,perfDE] = deopt('objfun',S_struct)


% simulated annealing
%--------------------------------------------------------------------
options = saoptimset(@simulannealbnd);
options.ObjectiveLimit = fMin;
options.TolFun = 1e-16;
% options.MaxIter = min(maxeval*S_struct.I_NP,perfDE.itertotal);
options.MaxIter = 2000;
options.StallIterLimit = options.MaxIter;
options.MaxFunEvals = options.MaxIter;
options.Display = 'diagnose';
options.DisplayInterval = 200;
options.InitialTemperature = 600;
options.ReannealInterval = min(ceil(.5*options.MaxIter),200);
hybridopts = optimset('MaxIter',maxeval,'TolFun',tol,'Algorithm','sqp','OutputFcn',@myOutputSAHybrid);
options.HybridFcn = {@fmincon,hybridopts};
options.HybridInterval = 'end';
% options.TemperatureFcn = @temperatureboltz;
% options.AnnealingFcn = @annealingboltz;
options.TemperatureFcn = @temperaturefast;
options.OutputFcns = @myOutputSA;


global structSA;
 
structSA.xk = [];
structSA.fk = [];
structSA.iter = 0;

[x,fval,exitflag,output] = simulannealbnd(fun,x0,lb+tol,ub-tol,options)

% Create figure
figure1 = figure('Color',[1 1 1]);
colormap('gray');

% Create axes
axes1 = axes('Parent',figure1,'FontSize',12);
loglog(1:perfSQP.iter,perfSQP.fk,'k-',1:perfDE.iter,[perfDE.fk,S_y.FVr_oa],'k--',1:structSA.iter,structSA.fk,'k.','LineWidth',1.5)
legend('SQP','DE','SA')

path(p)