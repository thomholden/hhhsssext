
function [theta,lambda] = fda(X,clusters,N)

%   [theta,lambda] = fda(X,clusters,N)
%   [theta,lambda] = fda(X,clusters)
%
% Fisher discriminant analysis.
%
% Input parameters:
%  - X: Input data block (k x n)
%  - clusters: Cluster index between 1 and N for all k samples,
%    constructed for example by K-means ('km.m')
%  - N: Number of discriminant axes (optional)
% Return parameters:
%  - theta: Discriminant axes
%  - lambda: Corresponding eigenvalues
%
% Heikki Hyotyniemi Feb.20, 2001


[k,n] = size(X);
NN = max(clusters);
centers = zeros(n,NN);
for i = 1:NN
   centers(:,i) = mean(X(find(clusters==i),:))';
end

center = mean(X);
Rtotal = (X-ones(k,1)*center)'*(X-ones(k,1)*center)/k;
Rwithin = (X-centers(:,clusters)')'*(X-centers(:,clusters)')/k;
Rbetween = Rtotal - Rwithin;

[THETA,LAMBDA] = eig(Rbetween,Rwithin);
[LAMBDA,order] = sort(abs(diag(LAMBDA)));
LAMBDA = flipud(LAMBDA);
THETA = THETA(:,flipud(order));

if nargin<3 | isnan(N) | isinf(N) | isempty(N)
   N = askorder(LAMBDA);
end

theta = THETA(:,1:N);
lambda = LAMBDA(1:N);

