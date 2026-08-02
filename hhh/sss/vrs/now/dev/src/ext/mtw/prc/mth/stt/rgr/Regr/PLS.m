
function [theta,phi,lambda] = pls(X,Y,N)

%   [theta,phi,lambda] = pls(X,Y,N)
%   [theta,phi,lambda] = pls(X,Y)
%
% Partial Least Squares Regression (PLS) construction (simplified)
%
% Input parameters:
%  - X: Input data block (k x n)
%  - Y: Output data block (k x m)
%  - N: Number of latent variables (optional)
% Return parameters:
%  - theta: Input block eigenvectors
%  - phi: Output block eigenvectors
%  - lambda: Square roots of corresponding eigenvalues
%
% Heikki Hyotyniemi Dec 21, 2000


[kx,n] = size(X);
[ky,m] = size(Y);
NN = min(n,m);
if ky == kx
   k = kx;
else
   error('Incompatible input and output blocks');
   return;
end

R = X'*Y/m;
[THETA,LAMBDA,PHI] = svd(R);
LAMBDA = abs(diag(LAMBDA));

%R = X'*Y*Y'*X/k^2;
%[THETA,LAMBDA] = eig(R);
%[LAMBDA,order] = sort(abs(diag(LAMBDA)));
%LAMBDA = flipud(sqrt(LAMBDA));
%THETA = THETA(:,flipud(order));

if nargin>2 & ~isnan(N) & ~isempty(N)
   N = min(N,n);
   N = min(N,m);
else
   LAMBDA = LAMBDA(1:min(n,m));
   N = askorder(LAMBDA);
end

theta = THETA(:,1:N);
phi = PHI(:,1:N);
lambda = LAMBDA(1:N);
