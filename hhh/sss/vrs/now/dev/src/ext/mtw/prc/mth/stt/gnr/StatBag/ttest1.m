function [t,p] = ttest1(x1,x2)

% function [t,p] = ttest1(x1,x2)
% Do ONE-SIDED t-test on sample
% x1 	first sample
% x2	second sample
% p 	probability that Pop Mean (x2) > Pop Mean (x1)
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

if m2>m1
	return
else
 	p=1-p;
end

% If data values are very small (machine precis.) then test is unreliable
if m2-m1<eps
	p=1;
end

