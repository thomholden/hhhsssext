function [D] = multinom_helling(alpha_q,alpha_p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   [D] = multinom_helling (alpha_q,alpha_p)
%
%   computes the Hellinger Distance 
%   given as
%             /
%      D^2 = | (q(x)-p(x))^2 dx
%            /
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

D=sqrt(sum((alpha_q-alpha_p).^2));