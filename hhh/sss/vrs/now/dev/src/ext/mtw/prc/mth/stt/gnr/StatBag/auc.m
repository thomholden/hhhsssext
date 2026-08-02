function [a] = auc(x,y)

% function [a] = auc(x,y)
% Area under the Receiver Operating Characteristic curve
% It is identical to the Wilcoxon statistic 

x=x(:);
y=y(:);
[c,n,t] = concordance(x,y);
N=size(x,1);
a=(c+0.5*t)/N^2;

