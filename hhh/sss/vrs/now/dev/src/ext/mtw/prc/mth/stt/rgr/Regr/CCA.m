
function [theta,phi,lambda] = cca(X,Y,N)

%   [theta,phi,lambda] = cca(X,Y,N)
%   [theta,phi,lambda] = cca(X,Y)
%
% Canonical Correlation Analysis (CCA) model construction
%
% Input parameters:
%  - X: Input data block (size k x n)
%  - Y: Output data block (size k x m)
%  - N: Number of latent variables (optional)
% Return parameters:
%  - theta: Input block canonical variates
%  - phi: Output block canonical variates
%  - lambda: Canonical correlation coefficients
%
% Heikki Hyotyniemi Feb.12, 2000


[kx,n] = size(X);
[ky,m] = size(Y);
NN = min(n,m);
if ky == kx
   k = kx;
else
   error('Incompatible input and output blocks');
   return;
end

V = [X,Y];
R = V'*V/k;   
R11 = R(1:n,1:n);
R12 = R(1:n,n+1:n+m);
R22 = R(n+1:n+m,n+1:n+m);
if (min(abs(eig(R11)))<norm(R11)*n*eps)
   disp('X block singular! Results may be inaccurate'); 
end
if (min(abs(eig(R22)))<norm(R22)*n*eps)
   disp('Y block singular! Results may be inaccurate'); 
end
   
[THETA,LAMBDA] = eig(inv(R11)*R12*inv(R22)*R12');
[LAMBDA,order] = sort(abs(diag(LAMBDA)));
LAMBDA = flipud(LAMBDA);
THETA = THETA(:,flipud(order));

[PHI,LAMBDA] = eig(inv(R22)*R12'*inv(R11)*R12);
[LAMBDA,order] = sort(abs(diag(LAMBDA)));
LAMBDA = flipud(sqrt(LAMBDA));
PHI = PHI(:,flipud(order));

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

theta = theta*inv(sqrt(diag(diag(theta'*R11*theta))));  % Scaling!
phi = phi*inv(sqrt(diag(diag(phi'*R22*phi))));

