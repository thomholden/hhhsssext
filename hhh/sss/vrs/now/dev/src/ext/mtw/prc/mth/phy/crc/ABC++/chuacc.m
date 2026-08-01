function TimeSeries = chuacc(L,R0,C2,G,Ga,Gb,C1,E,x0,y0,z0,dataset_size,step_size)
%0.00945,7.5,2e-007,0.00105,0,-0.00121,1.5e-008,1.76e-005,0,-0.1,0.1,2500,5e-6






% Syntax: TimeSeries=chua(L,R0,C2,G,Ga,Gb,C1,E,x0,y0,z0,dataset_size,step_size)
% ______________________________________
%
% Chua's oscillator is described by a  set  of  three
% ordinary differential equations called Chua's equations:
%
%      dI3      R0      1
%      --- =  - -- I3 - - V2
%      dt       L       L
%
%      dV2    1       G
%      --- = -- I3 - -- (V2 - V1)
%      dt    C2      C2
%
%      dV1    G              1
%      --- = -- (V2 - V1) - -- f(V1)
%      dt    C1             C1
%
% where
%
%   f(V1) = Gb V1 + - (Ga - Gb)(|V1 + E| - |V1 - E|)
%
% A solution of these equations (I3,V2,V1)(t) starting from an
% initial state (I3,V2,V1)(0) is called a trajectory of Chua's
% oscillator.
%
% This function uses a RungeKutta integration method optimised for the chua
% paradigm
%
% Reference:
% ABC - Adventures in Bifurication & Chaos ... Prof M.P Kennedy 1993
%
%
% James McEvoy, Tom Murray
% 
% University e-mail: 99375940@student.ucc.ie
% Lifetime e-mail: sacevoy@eircom.net
% Homepage: http://www.sacevoy.com
%
% 2 Nov 2002




% Models Initial Variables
%-------------------------
%Initial Conditions set by x0,y0,z0
TimeSeries = [x0, y0, z0]'; % models initial conditions 
                            %x0 = I3, y0 = V2, z0 = V1 from datafiles
                            


% Optimized Runge-Kutta Variables
%--------------------------------

h = step_size; %*(G/C2);
h2 = (h)*(.5);
h6 = (h)/(6);


sys_variables(9:12) = [1.76e-005,0,-0.00121,0];

k1 = [0 0 0]';
k2 = [0 0 0]';
k3 = [0 0 0]';
k4 = [0 0 0]';
M = [0 0 0]';

% Calculate Time Series
%----------------------
% values have to be switched around 
M(1) = TimeSeries(3);   %V1
M(2) = TimeSeries(2);   %V2 
M(3) = TimeSeries(1); %I3

for i=1:dataset_size
    % Runge Kutta
    % Round One
    k1(1) = (G*(M(2) - M(1)) - gnor(M(1),sys_variables))/C1;
    k1(2) = (G*(M(1) - M(2)) + M(3))/C2;
    k1(3) = (-(M(2) + R0*M(3)))/L;
    % Round Two
    k2(1) = (G*(M(2) + h2*k1(2) - (M(1) + h2*k1(1))) - gnor(M(1) + h2*k1(1),sys_variables))/C1;
    k2(2) = (G*(M(1) + h2*k1(1) - (M(2) + h2*k1(2))) + M(3) + h2*k1(3))/C2;
    k2(3) = (-(M(2) + h2*k1(2) + R0*(M(3) + h2*k1(3))))/L;
    % Round Three
    k3(1) = (G*(M(2) + h2*k2(2) - (M(1) + h2*k2(1))) - gnor(M(1) + h2*k2(1),sys_variables))/C1;
    k3(2) = (G*(M(1) + h2*k2(1) - (M(2) + h2*k2(2))) + M(3) + h2*k2(3))/C2;
    k3(3) = (-(M(2) + h2*k2(2) + R0*(M(3) + h2*k2(3))))/L;
    
    % Round Four
    k4(1) = (G*(M(2) + h*k3(2) - (M(1) + h*k3(1))) - gnor(M(1) + h*k3(1),sys_variables))/C1;
    k4(2) = (G*(M(1) + h*k3(1) - (M(2) + h*k3(2))) + M(3) + h*k3(3))/C2;
    k4(3) = (-(M(2) + h*k3(2) + R0*(M(3) + h*k3(3))))/L;
    
    M = M + (k1 + 2*k2 + 2*k3 + k4)*(h6); %Finishes integration and assigns values to M(1),
                                          %M(2) and M(3)   
    
    TimeSeries(3,i+1) = M(1);  %TimeSeries 3 is V1
    TimeSeries(2,i+1) = M(2);  %TimeSeries 2 is V2
    TimeSeries(1,i+1) = M(3); %TimeSeries 1 is I3
    
    i=i+1;
end
%gnor Calculates the cubic nonlinearity
function gnor =  gnor(x,sys_variables)

    a = sys_variables(9);
    b = sys_variables(10);
    c = sys_variables(11);
    d = sys_variables(12);
    
    gnor = a*(x.^3) + b*(x.^2) + c*x + d;