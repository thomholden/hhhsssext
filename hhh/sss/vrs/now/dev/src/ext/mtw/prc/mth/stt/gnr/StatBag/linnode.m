function [y] = linnode (x,w)

% function [y] = linnode (x,w)
% A linear node

w=w(:);
N=size(x,1);
xx=[x,ones(N,1)];
y=xx*w;

