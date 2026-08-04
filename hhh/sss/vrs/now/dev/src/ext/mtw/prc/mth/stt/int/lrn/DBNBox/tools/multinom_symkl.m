function [D,Dq_p,Dp_q] = multinom_symkl(alpha_q,alpha_p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   [D,Dq_p,Dp_q] = multinom_symkl (alpha_q,alpha_p)
%
%   computes the symmetrized KL divergence D=D(q||p)+D(p||q)
%   given as
%                /
%      D(q||p) = | (q(x)-p(x))*log(q(x)/p(x)) dx
%               /
%   between two k-dimensional multinomial propability densities
%              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<2,
  error('Incorrect number of input arguements');
end;

if length(alpha_q)~=length(alpha_p),
  error('Distributions must have equal dimensions');
end;
alpha_q=alpha_q(:);
alpha_p=alpha_p(:);
K=length(alpha_q);


Dq_p=(alpha_q)'*(log(alpha_q)-log(alpha_p));
Dp_q=(alpha_q)'*(log(alpha_q)-log(alpha_p));

D=(alpha_q-alpha_p)'*(log(alpha_q)-log(alpha_p));
%D=Dq_p+Dp_q



