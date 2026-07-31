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



%--------------------------------------
% scriptAckleySA.m 
%--------------------------------------

% lower/upper bounds
lb = [-3;-3]; ub = [3;3];
% objective function
fun = @ackley;
% initial guess
x0 = lb;

% Load/Set state of the random number generator.
load rngState
set(RandStream.getDefaultStream,'State',rngState.state);

% Set options of the Simulated Annealing algorithm
options = saoptimset(@simulannealbnd);
options.ObjectiveLimit = 1e-10; % objective function value to reach
options.TolFun = 1e-12; % average change in function values
options.MaxIter = 500; % maximum number of iterations
options.Display = 'diagnose'; % display intermediate results
options.DisplayInterval = 60; % display interval
options.InitialTemperature = 50; % initial temperature
options.ReannealInterval = 200; % iterations till reannealing

structF.x = -3:0.05:3;
structF.y = structF.x;

ackleyFun = @(X,Y)(exp(1)+20*(1-exp(-0.2*sqrt(0.5*(X.^2+Y.^2))))...
                    -exp(0.5*(cos(2*pi*X)+cos(2*pi*Y))));

[xx,yy]=meshgrid(structF.x,structF.y) ;
structF.z = ackleyFun(xx,yy);

%plot best solution
options.PlotFcns = @(a,b,c)PlotItBest(a,b,c,structF);
options.PlotIntervall = 5;


% start optimization
[x,fval,exitflag,output] = simulannealbnd(fun,x0,lb,ub,options)