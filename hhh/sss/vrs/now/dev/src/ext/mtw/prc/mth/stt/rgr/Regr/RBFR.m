
function [Yhat] = rbfr(X,rbfmodel)

%   [Yhat] = rbfr(X,rbfmodel)
%
% Radial Basis Function regression.
%
% Input parameters:
%  - X: Input data block (k x n)
%  - rbfmodel: Matrix containing the model in the form
%    rbfmodel = [centers;sigmas;weights], where
%     - centers: Vector (n x N) containing cluster centers
%     - sigmas: Optimized cluster standard deviations
%     - weights: Mappings (m x N) from cluster to outputs
% Return parameters:
%  - Yhat: Output data block (k x m)
%
% Heikki Hyotyniemi Feb.21, 2001


[k,n] = size(X);
[N,nm1] = size(rbfmodel);
m = nm1 - n -1;

centers = rbfmodel(:,1:n)';
sigmas = rbfmodel(:,n+1)';
F = rbfmodel(:,n+2:nm1);

dist2 = sum(X.*X,2)*ones(1,N) - 2*X*centers + ones(k,1)*sum(centers.*centers,1);

p = exp(-dist2./(ones(k,1)*sigmas));
p = p./(sum(p')'*ones(1,N));
Yhat = p*F;
