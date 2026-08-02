function [m,c,x0,xn,y0,yn]=regress(x,y)

% Univariate linear regression

mx=mean(x);
my=mean(y);
n=size(x,1);
sxx=sum(x.^2)-n*mx^2;
sxy=sum(x.*y)-n*mx*my;
m=sxy/sxx;
c=my-m*mx;

x0=min(x);
y0=m*x0+c;
xn=max(x);
yn=m*xn+c;
%plot([x0 xn],[y0 yn],'r');
