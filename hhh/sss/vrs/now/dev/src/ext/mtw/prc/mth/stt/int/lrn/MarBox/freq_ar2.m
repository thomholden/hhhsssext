function [p,f] = freq_ar2 (a1,a2,T)

% From Chatfield p.101

w=[1/T:1/T:pi];
p=1./(1+a1^2+a2^2-2*a1*(1-a2)*cos(w)-2*a2*cos(2*w));
p=p./pi;

f=w./(2*pi);
f=f*T;

