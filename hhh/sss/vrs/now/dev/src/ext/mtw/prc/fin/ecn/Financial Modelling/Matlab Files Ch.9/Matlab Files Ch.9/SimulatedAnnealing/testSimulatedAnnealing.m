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
%    Simulated Annealing Test Script
%--------------------------------------

close all
clear all
clc

% Example 1: Ackley's function
%--------------------------------------
% lower/upper bounds
lb = [-3;-3]; ub = [3;3];
% objective function
fun = @ackley;

options = saoptimset(@simulannealbnd);
options.ObjectiveLimit = 1e-10;
options.TolFun = 1e-12;
%options.StallIterLimit = 50000;
options.MaxIter = 500;
%options.MaxFunEvals = options.MaxIter;
options.Display = 'diagnose';
options.DisplayInterval = 60;
options.InitialTemperature = 50;
options.ReannealInterval = 200;%min(ceil(.5*options.MaxIter),100);
%options.OutputFcns = @displayOutputSA;
%options.TemperatureFcn = @temperatureboltz;



S_struct.FVc_xx = -3:0.05:3;
S_struct.FVc_yy = S_struct.FVc_xx;

ackleyFun = @(X,Y)(exp(1)+20*(1-exp(-0.2*sqrt(0.5*(X.^2+Y.^2))))...
                    -exp(0.5*(cos(2*pi*X)+cos(2*pi*Y))));

[FM_x,FM_y] = meshgrid(S_struct.FVc_xx,S_struct.FVc_yy) ;
S_struct.FM_meshd = ackleyFun(FM_x,FM_y);

%plot best solution
%options.PlotFcns = @(a,b,c)PlotItBest(a,b,c,S_struct);
% %plot current solution
options.PlotFcns = @(a,b,c)PlotItCurrent(a,b,c,S_struct);
options.PlotIntervall = 5;

load outputSA

% We reset the state of the random number generator.
set(RandStream.getDefaultStream,'State',output.rngstate.state);

x0 = lb;
%start optimization
[x,fval,exitflag,output] = simulannealbnd(fun,x0,lb,ub,options);


% nrBatches = 1;
% iterVec = zeros(nrBatches,1);
% timeVec = zeros(nrBatches,1);
% fvalVec = zeros(nrBatches,1);
% for i = 1:nrBatches
% 
% % initial guess
% x0 = (ub-lb).*rand(2,1)+lb;
% %start optimization
% [x,fval,exitflag,output] = simulannealbnd(fun,x0,lb,ub,options);
% iterVec(i) = output.iterations;
% timeVec(i) = output.totaltime;
% fvalVec(i) = fval;
% end
% 
% iterMean = mean(iterVec)
% iterStd = std(iterVec)
% timeMean = mean(timeVec)
% timeStd = std(timeVec)
% min(fvalVec)
% max(fvalVec)
% mean(fvalVec)