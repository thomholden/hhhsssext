
function [Xhat,Yhat] = kalm(Y,A,C,Rxx,Ryy,Rxy,x0)

%   [Xhat,Yhat] = kalman(Y,A,C,Rxx,Ryy,Rxy,x0)
%   [Xhat,Yhat] = kalman(Y,A,C,Rxx,Ryy,Rxy)
%
% Discrete time stochastic Kalman filter.
%
% Input parameters:
%  - Y: Output data block (k x m)
%  - A,C,Rxx,Ryy,Rxy: System matrices
%  - x0: Initial state (default x0=0)
% Return parameters:
%  - Xhat: State sequence estimate
%  - Yhat: Corresponding output estimate
%
% Heikki Hyotyniemi Sep.13, 2000


[k,m] = size(Y);
[n1,n2] = size(A);
if n1~=n2, disp('Matrix A not square!'); 
else n = n1;
end

U = zeros(k,1);
B = zeros(n,1);
D = zeros(m,1);
if nargin == 7
   [Xhat,Yhat] = kalman(U,Y,A,B,C,D,Rxx,Ryy,Rxy,x0);
else
   [Xhat,Yhat] = kalman(U,Y,A,B,C,D,Rxx,Ryy,Rxy);
end


