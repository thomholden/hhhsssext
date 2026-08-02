function [t,p] = ttest(x1,x2)

% function [t,p] = ttest(x1,x2)
% Do t-test on sample
% x1 	first sample
% x2	second sample
% p 	probability that samples a and b are from a distribution with the same mean (a and b are assumed to have the same variance)
% t 	corresponding t value

x1=x1(:);
x2=x2(:);

n1=length(x1);
n2=length(x2);

m1=mean(x1);
m2=mean(x2);

s1=std(x1);
s2=std(x2);

[t,p] = ttest_stat (n1,m1,s1,n2,m2,s2);

