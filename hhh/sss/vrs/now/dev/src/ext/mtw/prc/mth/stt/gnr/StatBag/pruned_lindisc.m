function [w,vars] = pruned_lindisc (c0,c1,plevel);

% function [w,vars] = pruned_lindisc (c0,c1,plevel);
% Train and prune linear discriminant analysis unit
% See Press p.698-699

n0=size(c0,1);
n1=size(c1,1);
% 0,1 targets
t=[zeros(n0,1); ones(n1,1)];
x=[c0; c1];

[w,vars]=pruned_lda(x,t,plevel);
