
function [clusters] = em(X,N,centers,equal)

%   [clusters] = em(X,N,centers,equal)
%   [clusters] = em(X,N,centers)
%   [clusters] = em(X,N)
%
% Function for determining the clusters using EM algorithm.
%
% Input parameters:
%  - X: Data to be modeled; collection of row vector samples (size k x n)
%  - N: Number of clusters
%  - centers: Cluster center points (optional)
%  - equal: '1' if distributions within clusters are equal (default equal=0)
% Return parameters:
%  - clusters: Vector (k x 1) showing the clusters for samples
%
% Heikki Hyotyniemi Dec.21, 2000


[k,n] = size(X);
if nargin < 4 | isempty(equal) | isnan(equal)
   equal = 0;
end
if nargin < 3 | isempty(centers) | isnan(centers)
   centers = X(1:N,:)';
   clusters = km(X,N,centers);
   for i = 1:N
      centers(:,i) = mean(X(find(clusters==i),:))';
   end
   disp('Data points divided in preliminary clusters');
end

if size(centers,1) ~= n | size(centers,2) ~= N
   disp('Incompatible cluster center vectors');
end

OK = 0;
while ~OK 
   oldclusters = clusters;   
   covX = cov(X-centers(:,clusters)');
   for i = 1:k
      for j = 1:N
         meanX = mean(X(find(clusters==j),:))';
         if ~equal
            covX = cov(X(find(clusters==j),:));
         end
         p(j) = (2*pi)^(-n/2)*(det(covX)+eps)^(-1/2);
         p(j) = p(j)*exp(-(X(i,:)'-meanX)'*inv(covX)*(X(i,:)'-meanX)/2);
      end
      [maxp,maxi] = max(p);
      clusters(i) = maxi;
   end
   for i = 1:N
      centers(:,i) = mean(X(find(clusters==i),:))';
   end
   disp(['percentage ',num2str(100*sum(clusters-oldclusters==0)/k),' solved']);
   if clusters == oldclusters
      OK = 1;
   end
end
disp('EM algorithm performed')
