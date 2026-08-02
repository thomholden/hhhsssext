
function [clusters] = km(X,N,centers)

%   [clusters] = km(X,N,centers)
%   [clusters] = km(X,N)
%
% Function for determining the clusters using K-means algorithm.
%
% Input parameters:
%  - X: Data to be modeled; collection of row vector samples
%  - N: Number of clusters
%  - centers: Initial cluster center points (optional)
% Return parameters:
%  - clusters: Vector (k x 1) showing the clusters for samples
%
% Heikki Hyotyniemi Dec.21, 2000


if nargin < 3 | isempty(centers) | isnan(centers)
   centers = X(1:N,:)';
end

[k,n] = size(X);
if size(centers,1) ~= n | size(centers,2) ~= N
   disp('Incompatible cluster center vectors');
end

clusters = rem([0:k-1]',N) + 1;

OK = 0;
while ~OK 
   oldclusters = clusters;   
   for i = 1:k
      dist2 = zeros(N,1);
      for j = 1:N
         dist2(j) = (X(i,:)'-centers(:,j))'*(X(i,:)'-centers(:,j));
      end
      [mind,mini] = min(dist2);
      clusters(i) = mini;
   end
   for i = 1:N
      centers(:,i) = mean(X(find(clusters==i),:))';
   end
   disp(['percentage ',num2str(100*sum(clusters-oldclusters==0)/k),' solved']);
   if clusters == oldclusters
      OK = 1;
   end   
end
disp('K-means algorithm performed')
