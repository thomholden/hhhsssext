function [x,y,e] = coherent (f,total_seconds, ns, noise)

% function [x,y,e] = coherent (f,total_seconds, ns, noise)
%
% Generate two coherent 10Hz time-series

%total_seconds=2;
%ns=128;

t=[1/ns:1/ns:total_seconds];
T=size(t,2);
s=sin(2*pi*f*t);
s2=s;
e1=noise*randn(1,T);
x=s+e1;

% make y correlated to x
e2=noise*randn(1,T);
y=s2+e2;

e=[e1;e2];

