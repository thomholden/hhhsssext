function [class] = clindisc(c0, c1, pattern)

% function [class] = clindisc(c0, c1, pattern)

n0=size(c0,1);
n1=size(c1,1);
class0=[c0, ones(n0,1)];
class1=[c1, ones(n1,1)];

% 0,1 targets
t=[zeros(n0,1); ones(n1,1)];

% -1,+1 targets
%t=[-1*ones(n0,1); ones(n1,1)];

x=[class0; class1];

% w(3) will be bias term
w=pinv(x)*t;

x_input=[pattern,1];
y=x_input*w;

if y > 0.5
	class=1;
else
	class=0;
end
