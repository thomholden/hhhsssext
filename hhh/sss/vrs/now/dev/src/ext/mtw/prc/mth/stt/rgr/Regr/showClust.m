
function showclust(X,c)

%   showclust(X,c)
%   showclust(X)
%
% Function visualizes clusters. 
%
% Input parameters:
%  - X: Data to be modeled (size k x n)
%  - c: Cluster indices for data (optional)
%
% Heikki Hyotyniemi Dec.21, 2000


[k,n] = size(X);
colors = 'rgbkymc';
if nargin<2
   c = ones(k,1);
end

[V,L] = eig(X'*X/k);
[LL,order] = sort(diag(L));
LL = flipud(LL);
order = flipud(order);
V = V(:,order);

if n > 2
   pc = [1,2,3];
elseif n > 1
   pc = [1,2];
else
   pc = [1];
end

while length(pc) ~= 0 
   axes = V(:,pc);
   Z = X*axes;
   figure(1);
   clf;
   hold on;
   for i = 1:k
      if length(pc) == 1
         plot(i,Z(i,1),[colors(rem(c(i),7)+1),'*']);
      end
      if length(pc) == 2
         plot(Z(i,1),Z(i,2),[colors(rem(c(i),7)+1),'*']);
      end
      if length(pc) == 3
         plot3(Z(i,1),Z(i,2),Z(i,3),[colors(rem(c(i),7)+1),'*']);
         view([30,30]);
      end           
   end   
   if length(pc)==3
      xlabel(['Principal component ',num2str(pc(1))]);
      ylabel(['Principal component ',num2str(pc(2))]);
      zlabel(['Principal component ',num2str(pc(3))]);
      title('Three-dimensional view');
   elseif length(pc) == 1
      xlabel(['Data index']);   
      ylabel(['Principal component ',num2str(pc(1))]);
   elseif length(pc) == 2
      xlabel(['Principal component ',num2str(pc(1))]);   
      ylabel(['Principal component ',num2str(pc(2))]);
   end
   pc = input('Give pc''s to project the data onto (1, 2, or 3 in list form, or <cr>)  ');
end
