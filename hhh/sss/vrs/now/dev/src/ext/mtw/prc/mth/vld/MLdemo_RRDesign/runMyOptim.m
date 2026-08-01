%% Set Up Traditional Design
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

x1
