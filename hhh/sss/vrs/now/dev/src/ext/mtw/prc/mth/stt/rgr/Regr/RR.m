
function [F,error] = rr(X,Y,q)

%   [F,error] = rr(X,Y,q)
%
% Ridge Regression.
%
% Input parameters:
%  - X: Input data block (k x n)
%  - Y: Output data block (k x m)
%  - q: Stabiliaztion factor
% Return parameters:
%  - F: Mapping matrix, Yhat = X*F
%  - error: Prediction errors
%
% Heikki Hyotyniemi Dec.21, 2000


[kx,n] = size(X);
[ky,m] = size(Y);
if kx ~= ky, disp('Incompatible X and Y'); break; end

F = inv(X'*X+q*eye(n))*X'*Y;

Yhat = X*F;
error = Y - Yhat;
