function [x]= gaussian2D(N,mean,r)


% function [x]= gaussian2D(N,mean,r)
% FUNCTION: Returns N 2-dimensional points normally distributed about
% the given mean according to the given covariance matrix r
% EXAMPLE: >> gaussian2D(1000,[7,5],[1 0.5; 0.5 1])
% USES: normal.m
% W. Penny 20 May 1996

% Diagonalize covariance matrix to find size (eigenvalue, s) and
% orientation (eigenvector, v) of independent gaussian components

[v,s] = eig(r);

% Generate independent gaussian components

xv(1,:)=normal(N,0,s(1,1))';
xv(2,:)=normal(N,0,s(2,2))';

% Project them back to the original (non-diagonalized) axes
% and add mean

x=inv(v')*xv;
xmean=[mean(1)*ones(1,N);mean(2)*ones(1,N)];
x=x+xmean;
x=x';









