
function [theta,lambda] = cr(X,Y,alpha,N)

%   [theta,lambda] = cr(X,Y,alpha,N)
%   [theta,lambda] = cr(X,Y,alpha)
%
% Continuum regression.
%
% Input parameters:
%  - X: Input data block (k x n)
%  - Y: Output data block (k x m)
%  - alpha: Continuum parameter: from 0 (PCR) to ~1 (MLR)
%  - N: Dimension of the latent structure (optional)
% Return parameters:
%  - theta: Latent vectors
%  - lambda: Corresponding eigenvalues
%
% Heikki Hyotyniemi Sep.2, 2000


[kx,n] = size(X);
[ky,m] = size(Y);
NN = min(n,m);
if ky == kx
   k = kx;
else
   error('Incompatible input and output blocks');
   return;
end

% Formally calculate 
% R = X'*(Y*(Y'*Y)^(2*alpha-1)*Y')^(-2*alpha^2+alpha+1)*X/(k^(alpha+2));   
% However, Y*(Y'*Y)^(2*alpha-1)*Y' is huge!

[U,S,V] = svd(Y);           % Singular value decomposition
s = diag(diag(S(1:m,1:m)).^(alpha/(1-alpha+m*eps)));
u = U(:,1:m);
R = X'*u*s'*s*u'*X/(k^(1/(1-alpha+m*eps)));

[THETA,LAMBDA] = eig(R);
[LAMBDA,order] = sort(abs(diag(LAMBDA)));
LAMBDA = flipud(LAMBDA);
THETA = THETA(:,flipud(order));

if nargin<4 | isnan(N) | isinf(N) | isempty(N)
   N = askorder(LAMBDA);
end

theta = THETA(:,1:N);
lambda = LAMBDA(1:N);

