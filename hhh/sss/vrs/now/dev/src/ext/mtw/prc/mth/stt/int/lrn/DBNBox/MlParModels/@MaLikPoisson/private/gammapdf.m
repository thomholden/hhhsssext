function [px] = gammapdf(x,alpha,beta,logoption)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   [px] = gammapdf (x,alpha,beta,logoption)
%
%   computes Gamma propability density for x  given
%   scale matrix parameter beta and shape parameter alpha
%
%               alpha
%         |beta|         alpha-1
%   p(x)= ------------- x        exp (-beta x)
%         Gamma (alpha)
%              
%
%
%   if logoption is set to one, the log-propability is returned
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin<4,
  logoption=0;
end;

if alpha<=0,
   error('alpha must be positive');
end;
if beta<=0,
   error('beta must be positive');
end;
if any(x<=0),
   error('Density only defined for positive x');
end;

x=x(:);
N=length(x);

normconst=alpha*log(beta)-gammaln(alpha);

px=zeros(N,1);
px = (alpha-1)*log(x) - beta*x;

if logoption
  px=px+normconst;
else
  px=exp(px+normconst);
end;

