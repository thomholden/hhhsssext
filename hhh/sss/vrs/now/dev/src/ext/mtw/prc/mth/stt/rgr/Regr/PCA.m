
function [theta,lambda,Q,T2] = pca(X,N)

%   [theta,lambda,Q,T2] = pca(X,N)
%   [theta,lambda,Q,T2] = pca(X)
%
% Principal Component Analysis (PCA) 
%
% Input parameters:
%  - X: Input data block (m x nx)
%  - N: Number of latent variables (optional)
%       If negative, minor components returned
% Return parameters:
%  - theta: Latent basis
%  - lambda: Variances in latent basis directions
%  - Q,T2: Fitting criteria Q and T^2 (k x 1)
%
% Heikki Hyotyniemi Dec.21, 2000


[k,n] = size(X);
R = X'*X/k;
Q = zeros(k,1);
T2 = zeros(k,1);

[THETA,LAMBDA] = eig(R);
[LAMBDA,order] = sort(abs(diag(LAMBDA)));
LAMBDA = flipud(LAMBDA);
THETA = THETA(:,flipud(order));

if nargin>1 & N < 0
   N = abs(N);
   THETA = fliplr(THETA);
   LAMBDA = flipud(LAMBDA);
end

if nargin<2 | isnan(N) | isinf(N) | isempty(N)
   N = askorder(LAMBDA);
end

theta = THETA(:,1:N);
lambda = LAMBDA(1:N);

if nargout > 2
   for i = 1:k
      Q(i) = X(i,:)*(eye(n)-theta*theta')*X(i,:)';
      T2(i) = X(i,:)*theta*inv(diag(lambda))*theta'*X(i,:)';
   end
end

