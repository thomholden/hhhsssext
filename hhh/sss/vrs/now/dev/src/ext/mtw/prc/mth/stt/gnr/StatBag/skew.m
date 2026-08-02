function [sk] = skew (x)

%function [sk] = skew (x)
% Return skewness of variable, from Kleinbaum p. 188

x=x(:);
N=length(x);
xnorm=(x-mean(x))/std(x);
sk=(N/(N-2))*(1/(N-1))*sum(xnorm.^3);