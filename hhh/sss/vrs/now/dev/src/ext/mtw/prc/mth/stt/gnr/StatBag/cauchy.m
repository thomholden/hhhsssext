function [p] = cauchy (z)

p=1./(1+0.5*z.^2);
p=p/pi;
