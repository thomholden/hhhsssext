%% runMyOptimRR.m
% This MATLAB script carries out the complete reliability and robust design
% demo.  There are 3 parts, 1. Initial Design, 2. Traditional Optimization,
% and 3. Reliability and Robust Design. The last part simply plots the 3
% design points. 

% Copyright 2007, The MathWorks, Inc. 

%% Initial Design
% This is the initial guess used from previous model luxury car. 

% Load parameter configuration
configParams

% Initial design
x0 = [kf0 cf0 kr0 cr0];
cost0 = myCostFcn(x0);

%% Traditional Optimization Design
% Goal is to minimize the acceleration at the passenger locations.

% Variable definition
% kf = x(1); cf = x(2); kr = x(3); cr = x(4);

% Load parameter configuration
configParams

% Inequality constraints A*x <= b
A = [];
b = [];
% Equality constraints Aeq*x = beq
Aeq = [Lf 0 -Lr 0];                     % level car
beq = 0;
% Set lower and upper bounds
lb = [10000; 100; 10000; 100];
ub = [100000; 10000; 100000; 10000];
% Nonlinear constraints
% function handle @mynonlcon
% Set solver options
options = optimset;
options = optimset(options,'Display' ,'iter');
options = optimset(options,'TolFun' ,1e-08);
options = optimset(options,'LargeScale' ,'off');
% Starting point
x0 = [kf0 cf0 kr0 cr0];

% Run optimization
tic
[x1,cost1] = fmincon(@myCostFcn,x0,A,b,Aeq,beq,lb,ub,@mynonlcon,options);
toc

%% Reliability and Robust Design
% Goal is to minimize the acceleration at the passenger locations
% considering the reliability constraint and the robust design.  

% Variable definition
% kf = x(1); cf = x(2); kr = x(3); cr = x(4);

% Load parameter configuration
configParams

% Inequality constraints A*x <= b
A = [];
b = [];
% Equality constraints Aeq*x = beq
Aeq = [Lf0 0 -Lr0 0];                     % level car
beq = 0;
% Set lower and upper bounds
lb = [10000; 100; 10000; 100];
ub = [100000; 10000; 100000; 10000];
% Nonlinear constraints
% function handle @suspnonlcon1
% Set solver options
options = optimset;
%options = optimset(options,'Display' ,'iter');
options = optimset(options,'TolFun' ,1e-08);
options = optimset(options,'LargeScale' ,'off');
options = optimset(options,'MaxFunEvals' ,1000);
% Starting point
x0 = [kf0 cf0 kr0 cr0];

tic
% Initialize variables
nruns = 5;

x2_mc = zeros(4,nruns);
cost2_mc = zeros(1,nruns);

% Start Monte Carlo
for ii = 1:nruns
    % Vary the mass
    tweakmymass(Iyyempty,Mempty,Lf0,Lr0,rf0,rr0,rt0);
    
    % Run optimization
    [x2_mc(:,ii),cost2_mc(ii)] = fmincon(@myCostFcnRR,x0,A,b,Aeq,beq,lb,ub,@mynonlconRR,options);
       
end
toc

% Compute mean solution
x2 = mean(x2_mc,2);
cost2 = mean(cost2_mc);

% Display the histogram of the cost function
hist(cost2_mc)

% Save data
%save RRdesign x2_mc cost2_mc x2 cost2

% Observation
% All of the Monte Carlo optimizations where stopped by the same 3 
% nonlinear constraints.  The 3 contraints are the upper bound on the
% damping ratio for the front and rear suspensions, and the reliability
% constraint for the rear strut.  

%% Plot results
load Tdesign
load RRdesign
% Plot suspension design parameters
figure
    % Plot front spring constants
    subplot(2,2,1)
    bar([x0(1),x1(1),x2(1)])
    ylabel('k_f (N/m)')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
    
    % Plot front damping coefficients
    subplot(2,2,2)
    bar([x0(2),x1(2),x2(2)])
    ylabel('c_f (N/(m/s))')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
    
    % Plot rear spring constants
    subplot(2,2,3)
    bar([x0(3),x1(3),x2(3)])
    ylabel('k_r (N/m)')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
    
    % Plot front damping coefficients
    subplot(2,2,4)
    bar([x0(4),x1(4),x2(4)])
    ylabel('c_r (N/(m/s))')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
    
% Plot the cost function    
figure
    bar([cost0 cost1 cost2])
    ylabel('Cost Function')
    set(gca,'XTickLabel',{'Initial','Traditional','R & R'},...
    'XTick',[1 2 3]);
