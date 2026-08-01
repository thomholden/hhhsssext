%-----------------------------------------------
% Draws a circle at coord x,y of given color
% Author: Francisco de Castro (fdcastro@tld.net)
% To use with FDCgraph
%-----------------------------------------------
function []= circle(x,y,r,color)

t = (0:1/16:1)'*2*pi;
xx = x+ r*sin(t);
yy = y+ r*cos(t);
fill(xx,yy,color)
return
