function [AccCard] = FindAccCard(length,Card)
% Finds the accumulative cardinality of each variable in num. This is the product of cardinalities of previous 
% variables, where the first variable is  the one to left.
 AccCard(length) = 1;

for i=length-1:-1:1
    AccCard(i)=AccCard(i+1)*Card(i+1);
 end
