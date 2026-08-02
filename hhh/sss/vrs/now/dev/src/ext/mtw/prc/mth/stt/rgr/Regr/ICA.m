
function [theta,lambda] = ica(X,alpha,N)

%   [theta,lambda] = ica(X,alpha,N)
%   [theta,lambda] = ica(X,alpha)
%   [theta,lambda] = ica(X)
%
% Closed-form Independent Component Analysis (ICA)
%
% Input parameters:
%  - X: Whitened input data block, mixture of signals (k x n)
%  - alpha: Kurtotic or non-kurtotic signals searched (optional)
%  - N: Number of latent vectors (default all)
% Return parameters:
%  - theta: Independent directions
%  - lambda: Corresponding eigenvalues
%
% Heikki Hyotyniemi Sep.13, 2000


[k,n] = size(X);
if norm(eye(n)-X'*X/k) > 10^-1, disp('First whiten data!'); return; end

if nargin < 3
   N = n;  
end
if nargin < 2
   alpha = 1;  % Normal kurtosis-based ICA
end

normX = sqrt(sum(X'.*X')');
unnormX = normX.^alpha;
XX = (unnormX*ones(1,n)).*X;

R = XX'*XX/k;
[THETA,LAMBDA] = eig(R);
[LAMBDA,order] = sort(abs(diag(LAMBDA)));
LAMBDA = flipud(LAMBDA);
THETA = THETA(:,flipud(order));

if nargin<3
   Zhat = X*THETA;
   clf;
   for i = 1:n
      subplot(n,1,i);
      plot(Zhat(:,i));
      ylabel(['\lambda = ',num2str(LAMBDA(i))]);
      if i == 1, title('Independent signals'); end
   end
end

[LL,order] = sort(abs(LAMBDA-n-2));
order = flipud(order);
theta = THETA(:,order(1:N));
lambda = LAMBDA(order(1:N));
