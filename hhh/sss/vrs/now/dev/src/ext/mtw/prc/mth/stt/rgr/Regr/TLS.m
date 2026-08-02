
function [F,error] = tls(X,Y)

%   [F,error] = tls(X,Y)
%
% Total Least Squares regression 
%
% Input parameters:
%  - X: Input data block (k x n)
%  - Y: Output data block (k x m)
% Return parameters:
%  - F: Mapping matrix, Yhat = X*F
%  - error: Prediction errors
%
% Heikki Hyotyniemi Dec.21, 2000


[kx,n] = size(X);
[ky,m] = size(Y);
if kx ~= ky
   disp('Incompatible X and Y'); break; 
else
   k = kx;
end

F = zeros(n,m);
for i = 1:m
   Z = [Y(:,i),X];
   l = pca(Z,-1);
   F(:,i) = -l(2:length(l))/l(1);
end

Yhat = X*F;
error = Y - Yhat;
