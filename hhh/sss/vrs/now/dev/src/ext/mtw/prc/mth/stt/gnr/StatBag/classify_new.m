function [r] = classify_new (x,y,t)

% function [r] = classify_new (x,y,t)
% classify new data point from two class data problem 
% using decision threshold t

c=classify(x,y,t);
n=size(x,1);
r=0.5*c/n;
