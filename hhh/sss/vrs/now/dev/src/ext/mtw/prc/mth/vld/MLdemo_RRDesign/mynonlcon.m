function [c,ceq] = mynonlcon(x)
%% mynonlcon.m  Nonlinear constraints for fmincon.

% Inputs:
kf = x(1);
cf = x(2);
kr = x(3);
cr = x(4);

%% Initialize Variables
configParams

%% Define Desired Damping Coefficient
cd = 0.4;

%% Compute Constraints
Mf = Mempty*Lr/(Lf+Lr)/2;
Mr = Mempty*Lf/(Lf+Lr)/2;

% Inequality constraints c <= 0
c = [sqrt(x(1)/Mf)/(2*pi)-2;...             % fn <= 2 Hz for front
     sqrt(x(3)/Mf)/(2*pi)-2];               % fn <= 2 Hz for rear
% Equality constriants ceq = 0
ceq = [cd-x(2)/(2*sqrt(x(1)*Mf));...        % damping ratio for front
       cd-x(4)/(2*sqrt(x(3)*Mr))];          % damping ratio for rear
   
%% [EOF]