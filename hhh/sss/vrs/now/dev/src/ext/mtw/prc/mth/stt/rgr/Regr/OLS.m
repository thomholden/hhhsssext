
function [F,error] = ols(X,Y)

%   [F,error] = ols(X,Y)
%
% Orthogonal Least Squares (OLS) 
%
% Input parameters:
%  - X: Input data block (m x nx)
%  - Y: Output data block (m x nx)
% Return parameters:
%  - F: Mapping matrix, Yhat = X*F
%  - error: Prediction errors
%
% Heikki Hyotyniemi Dec.21, 2000


[kx,n] = size(X);
[ky,m] = size(Y);
if kx ~= ky
   disp('Incompatible X and Y'); break; 
end

[Q,R] = qr(X,0);  % "Economy-size" QR-factorization
M = inv(R);       % Should be solved from the normal equations!
F = M*M'*X'*Y;

Yhat = X*F;
error = Y - Yhat;
