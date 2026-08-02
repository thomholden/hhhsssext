function [w] = linreg(x, t)

% function [w] = linreg(x, t)
% Calcuate weight vector for linear regression

n=size(x,1);
xx=[x, ones(n,1)];

% w(n+1) will be bias term
w=pinv(xx)*t;


