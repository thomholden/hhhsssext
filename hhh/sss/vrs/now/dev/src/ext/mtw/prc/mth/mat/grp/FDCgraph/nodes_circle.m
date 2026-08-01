%-----------------------------------------------
% Calculates coordinates for nodes in FDCgraph
% Author: Francisco de Castro (fdcastro@tld.net)
% Nodes in a circle
%-----------------------------------------------
function [xy]= nodes_circle(a)

nsp= size(a,1);

t= 0;
for i= 1:nsp
   xy(i,1)= sin(t); xy(i,2)= cos(t);
   t= t+ 2*pi/nsp
end

return
