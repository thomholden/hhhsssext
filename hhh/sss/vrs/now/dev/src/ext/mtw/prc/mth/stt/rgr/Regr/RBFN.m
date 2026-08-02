
function [rbfmodel,error] = rbfn(X,Y,clusters,sigma)

%   [rbfmodel,error] = rbfn(X,Y,clusters,sigma)
%
% Radial Basis Function regression model construction.
%
% Input parameters:
%  - X: Input data block (k x n)
%  - Y: Output data block (k x m)
%  - clusters: Cluster index between 1 and N for all k samples,
%    constructed by K-means ('km.m') or SOM
%  - sigma: Distribution of the Gaussians
% Return parameters:
%  - rbfmodel: Matrix containing the model in the form
%    rbfmodel = [centers;sigmas;weights], where
%     - centers: Vector (n x N) containing cluster centers
%     - sigmas: Standard deviations in the clusters
%     - weights: Mappings (m x N) from cluster to outputs
%  - error: Prediction errors
%
% Heikki Hyotyniemi Feb.20, 2001


[kx,n] = size(X);
[ky,m] = size(Y);
if kx ~= ky, disp('Incompatible X and Y'); break; 
else k = kx; end

N = max(clusters);
centers = zeros(n,N);
for i = 1:N
   centers(:,i) = mean(X(find(clusters==i),:))';
end

dist2 = sum(X.*X,2)*ones(1,N) - 2*X*centers + ones(k,1)*sum(centers.*centers,1);

p = exp(-dist2/sigma);
p = p./(sum(p')'*ones(1,N));
F = mlr(p,Y);
error = Y - p*F;

rbfmodel = [centers',ones(N,1)*sigma,F];
