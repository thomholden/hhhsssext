function [c,ceq] = mynonlconRR(x)
%% mynonlconRR.m  Nonlinear constraints for fmincon for reliability and 
% robust design.

% Inputs:
kf = x(1);
cf = x(2);
kr = x(3);
cr = x(4);

%% Initialize Variables
global cycles
configParams

Plimit = 0.1;                              % max probability of shock absorber failure for lifetime

% Can tolerate a +/-10% change from desired damping coefficient
cupper = 0.44;                              % upper limit for damping coefficients
clower = 0.36;                              % lower limit for damping coefficients

%% Compute Constraints
Mf = Mempty*Lr0/(Lf0+Lr0)/2;
Mr = Mempty*Lf0/(Lf0+Lr0)/2;

% Inequality constraints c <= 0
c = [sqrt(x(1)/Mf)/(2*pi)-2;...             % fn <= 2 Hz for front
     sqrt(x(3)/Mf)/(2*pi)-2;...             % fn <= 2 Hz for rear
     x(2)/(2*sqrt(x(1)*Mf))-cupper;...      % damping ratio for front
     clower-x(2)/(2*sqrt(x(1)*Mf));...
     x(4)/(2*sqrt(x(3)*Mr))-cupper;...      % damping ratio for rear
     clower-x(4)/(2*sqrt(x(3)*Mr));...
     Pstrut(x(2),cycles) - Plimit;...       % front shock absorber reliability constraint
     Pstrut(x(4),cycles) - Plimit];         % rear shock absorber reliability constraint

% Equality constriants ceq = 0
ceq = [];

%% Pstrut Probability of Failure Function
function P = Pstrut(c,cycles)
% Computes the probability of strut failure for a given damping coefficient
% and a given number of lifetime cycles.

A = min(500*c,1000000);
B = 5;
P = wblcdf(cycles,A,B);     % probability of failure (Weibull Distribution)

% End of subfunction

%% [EOF]