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


% This script demonstrates the Levenberg-Marquardt optimization algorithm
% using functions MARQUARDT and SMARQUARDT of the IMMOPTIBOX toolbox,
% available from:
% http://www2.imm.dtu.dk/~hbn/immoptibox/
   
 p = path;
 addpath(genpath(pwd));
  
%% Example 1:
% %----------------------------------------------------------------------
% % number points
% Npnt = 250;
% % true parameters
% p_true  = [0.5 1.5 -2 0.03 0.05]';
% % experimental data outcome
% yfun = @(x,vecN)(x(1) + x(2)*exp(-x(4)*vecN) + x(3)*exp(-x(5)*vecN));
% 
% vecN = (1:Npnt)'-1;
% Y_true = yfun(p_true,vecN);
% 
% % initial guess
% x0  = [0  0.5  -0.5  0.1  0.1]';
% % objective function
% fun = @residualExample1;
% % additional parameter
% p1 = Y_true;
% %---------------------------------------------------------------------- 
 
%% Example 2: Meyer Function
% %----------------------------------------------------------------------
% % number points
% Npnt = 16;
% % true parameters
% p_true  = [0.00560964 6181.35 345.224]';
% % experimental data outcome
% yfun = @(x,vecN)(x(1)*exp(x(2)./(vecN+x(3))) );
% 
% vecN = 45 + 5*(1:Npnt)';
% Y_true = yfun(p_true,vecN);
% 
% % initial guess
% x0  = [0.02  4000  250]';
% % objective function
% fun = @residualExample2;
% % additional parameter
% p1 = Y_true;
% %-----------------------------------------------------------------------  
 
%% Example 3:
% %------------------------------------------------------------------------
% % number points
% Npnt = 45;
% % true parameters
% p_true  = [-4 -5 4 -4]';
% % experimental data outcome
% yfun = @(x,vecN)(x(3)*exp(x(1)*vecN)+x(4)*exp(x(2)*vecN) );
% 
% vecN = 0.02*(1:Npnt)';
% Y_true = yfun(p_true,vecN);
% 
% % initial guess
% x0  = [-1 -2 1 -1]';
% % objective function
% fun = @residualExample3;
% % additional parameter
% p1 = Y_true;
% %-----------------------------------------------------------------------


%% Example 4: Beale function
%--------------------------------------------------------------------
% initial guess
x0 = [-4 -4]';
% objective function
fun = @residualBeale; 
% additional parameter
p1 = sqrt(2);
%---------------------------------------------------------------------


%% initialize optimization procedure

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

[X,info,perf] = marquardt(fun,x0,opts,p1)
[sX,sinfo,sperf] = smarquardt(fun,x0,opts,[],p1)

[R0,J0] = fun(x0,p1);
[sX,sinfo,sperf] = smarquardt(fun,x0,opts,J0,p1)
[X,info] = marquardt(fun,x0,opts,p1)


path(p)