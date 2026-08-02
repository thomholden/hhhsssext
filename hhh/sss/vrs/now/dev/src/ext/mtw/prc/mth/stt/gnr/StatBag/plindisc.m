function [x2min,x2max] = plindisc(w,x1min,x1max)

% function [x2min,x2max] = plindisc(w,x1min,x1max)
% w(length(w)) is the threshold
% other w(i)'s are the coefficients of x(i)

x2min=(-w(1)*x1min-w(3)+0.5)/w(2);
x2max=(-w(1)*x1max-w(3)+0.5)/w(2);

plot([x1min,x1max],[x2min,x2max]);
%axis([x1min x1max]);
