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

% This script demonstrates the Differential Evolution optimization method
% by use of the DeMat-Toolbox, available from:
% http://www1.icsi.berkeley.edu/~storn/code.html#matl

clear all
close all
clc

p = path;
addpath(genpath(pwd));

%-----------------------------------------------------------------
% script file Rundeopt.m initializes and starts the optimization
%-----------------------------------------------------------------
% population constants
    S_struct.I_D = 2; % number of parameters being optimized
    S_struct.I_NP = 15; % number of population members
    S_struct.FVr_minbound = -3*ones(1,S_struct.I_D); % lower bounds
    S_struct.FVr_maxbound = 3*ones(1,S_struct.I_D); % upper bounds
% use/don't use as bound constraints if set to 1/0
    S_struct.I_bnd_constr = 1;	
% termination criteria
    S_struct.F_VTR = 1e-12;  % value to reach
	S_struct.I_itermax = 30; % maximum number of iterations
% define DE strategy
	S_struct.I_strategy = 1;  % classical DE 
    S_struct.F_weight = 0.85; % mutation scaling factor
    S_struct.F_CR = 0.8;      % crossover probabililty
    
%-----Plotting-----------------------------------------------------

% use/skip plotting if set to 1/0
    S_struct.I_plotting = 1;
% after "I_refresh" iterations plot/print values
    S_struct.I_refresh = 5;

if (S_struct.I_plotting == 1)
   S_struct.FVc_xx = -3:0.05:3;
   S_struct.FVc_yy = S_struct.FVc_xx;

   [FVr_x,FM_y]=meshgrid(S_struct.FVc_xx,S_struct.FVc_yy) ;
   S_struct.FM_meshd = ackley1(FVr_x,FM_y);

end

%---------Start optimization----------------------------------------
[FVr_x,S_y,I_nf] = deopt('objfun',S_struct)

path(p)