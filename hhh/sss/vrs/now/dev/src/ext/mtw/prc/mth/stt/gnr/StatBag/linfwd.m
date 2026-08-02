function [y] = linfwd(x, w)

% function [y] = linfwd(x, w)
% forward propagate through linear model

n=size(x,1);
xx=[x, ones(n,1)];

% w(n+1) will be bias term
y=xx*w;


