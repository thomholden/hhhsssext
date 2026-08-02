function [r, t] = classify_rate (x,y)

% function [r, t] = classify_rate (x,y)
% classify data from two class problem 
% use 'optimum' decision threshold
% return correct classification rate

t=getthresh(x,y);
c=classify(x,y,t);
n=size(x,1);
r=0.5*c/n;

