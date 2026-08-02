function [w] = quaddisc(c0, c1)

% function [w] = quaddisc(c0, c1)
% Calculate weight vector for two-class quadratic discriminant

n0=size(c0,1);
n1=size(c1,1);
class0=[c0, c0(:,1).^2, c0(:,2).^2, c0(:,1).*c0(:,2), ones(n0,1)];
class1=[c1, c1(:,1).^2, c1(:,2).^2, c1(:,1).*c1(:,2), ones(n1,1)];

% 0,1 targets
t=[zeros(n0,1); ones(n1,1)];

% -1,+1 targets
%t=[-1*ones(n0,1); ones(n1,1)];

x=[class0; class1];

% w(3) will be bias term
w=pinv(x)*t;

