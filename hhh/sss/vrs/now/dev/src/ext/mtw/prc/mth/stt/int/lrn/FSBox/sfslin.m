function [w,ssexp,sse] = sfslin (x,y)

% function [w,ssexp,sse] = sfslin (x,y)
% Linear regression model
% x		inputs
% y		targets
% 
% w		weight vector
% ssexp         sum of squares explained by model (ssy - sse)
% sse           sum of squared errors from model
 
n=size(x,1);
xx=[x, ones(n,1)];
y=y(:);

% w(n+1) will be bias term
w=pinv(xx)*y;

w=w(:);
xx=[x,ones(n,1)];
ypred=xx*w;

my=mean(y);
ssy=sum((y-my).^2);
sse=sum((y-ypred).^2);
ssexp=ssy-sse;