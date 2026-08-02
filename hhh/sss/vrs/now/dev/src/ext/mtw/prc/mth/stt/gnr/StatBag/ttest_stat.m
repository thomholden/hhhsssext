function [t,p] = ttest_stat (n1,m1,s1,n2,m2,s2)

% function [t,p] = ttest_stat (n1,m1,s1,n2,m2,s2)
% Do t-test on statistics of samples
% n1 	number of examples first sample
% m1	mean of first sample
% s1 	deviaton of first sample
% n2,m2,s2 stats for second sample
% p 	probability that samples are from a distribution with the same mean (they are assumed to have the same variance)
% t 	corresponding t value

var=((n1-1)*s1^2+(n2-1)*s2^2)/(n1+n2-2);
sp=sqrt(var);

denom=sp*sqrt(1/n1 + 1/n2);
t=(m1-m2)/denom;

% This t statistic is distributed as T with v=n1+n2-2 degrees of freedom

v=n1+n2-2;
x=v/(v+t^2);
a=v/2;
b=1/2;
p=betainc(x,a,b);
