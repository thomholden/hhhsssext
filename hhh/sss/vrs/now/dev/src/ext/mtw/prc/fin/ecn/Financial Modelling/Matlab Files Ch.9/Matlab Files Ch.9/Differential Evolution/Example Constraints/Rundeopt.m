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
    S_struct.I_D = 7; % number of parameters being optimized
    S_struct.I_NP = 5*S_struct.I_D; % number of population members
    S_struct.FVr_minbound = -10*ones(1,S_struct.I_D); % lower bounds
    S_struct.FVr_maxbound = 10*ones(1,S_struct.I_D); % upper bounds
% use/don't use as bound constraints if set to 1/0
    S_struct.I_bnd_constr = 1;	
% termination criteria
    S_struct.F_VTR = 680.631;  % value to reach
	S_struct.I_itermax = 10000; % maximum number of iterations
% define DE strategy
	S_struct.I_strategy = 1;  % classical DE 
    S_struct.F_weight = 0.7; % mutation scaling factor
    S_struct.F_CR = 0.6;      % crossover probabililty
    
%-----Plotting-----------------------------------------------------

% use/skip plotting if set to 1/0
    S_struct.I_plotting = 0;
% % after "I_refresh" iterations plot/print values
    S_struct.I_refresh = 50;
    
    fk = zeros(S_struct.I_itermax,4);
    iter = zeros(4,1);
    for i=1:4
        [FVr_x,S_y,I_nf,perf] = deopt('objfun',S_struct);
        iter(i) = perf.iter-1;
        fk(1:iter(i),i) = perf.fk';
    end
    
    % Create figure
    figure1 = figure('Color',[1 1 1]);

    % Create axes
    axes1 = axes('Parent',figure1,'YScale','log','YMinorTick','on',...
        'XScale','log',...
        'XMinorTick','on',...
        'FontSize',16);
    box(axes1,'on');
    hold(axes1,'all');
    
   
    % Create loglog
    loglog((1:iter(1))',fk(1:iter(1),1),'LineWidth',2,'Color',[0 0 0]);

    % Create loglog
    loglog((1:iter(2))',fk(1:iter(2),2),'LineWidth',2,'LineStyle',':','Color',[0 0 0]);

    % Create loglog
    loglog((1:iter(3))',fk(1:iter(3),3),'LineWidth',2,'LineStyle','--','Color',[0 0 0]);

    % Create loglog
    loglog((1:iter(4))',fk(1:iter(4),4),'LineWidth',2,'LineStyle','-.','Color',[0 0 0]);

    % Create xlabel
    xlabel('Iterations $k$','Interpreter','latex','FontSize',16);

    % Create ylabel
    ylabel('$f(x)$','Interpreter','latex','FontSize',16);

    % Create title
    title({'Best Objective Function Value $f(x)$ of Population $P_k$'},...
        'Interpreter','latex',...
        'FontSize',16);
    
    path(p)