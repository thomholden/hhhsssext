
function [F,error,R2] = mlr(X,Y,theta)

%   [F,error,R2] = mlr(X,Y,theta)
%   [F,error,R2] = mlr(X,Y)
%
% Regression from X to Y 
%
% Input parameters:
%  - X: Input data block (k x n)
%  - Y: Output data block (k x m)
%  - theta: Latent basis, orthogonal or not (optional)
% Return parameters:
%  - F: Mapping matrix, Yhat = X*F
%  - error: Prediction errors
%  - R2: Data fitting criterion R^2
%
% Heikki Hyotyniemi Dec.21, 2000


[kx,n] = size(X);
[ky,m] = size(Y);
if kx ~= ky, disp('Incompatible X and Y'); break; 
else k = kx; end

if nargin<3
   F = inv(X'*X)*X'*Y;
else
   F1 = theta*inv(theta'*theta);
   Z = X*F1;
   F2 = inv(Z'*Z)*Z'*Y;
   F = F1*F2;
end

Yhat = X*F;
error = Y - Yhat;
R2 = sum((Yhat).^2)./sum(Y.^2);
