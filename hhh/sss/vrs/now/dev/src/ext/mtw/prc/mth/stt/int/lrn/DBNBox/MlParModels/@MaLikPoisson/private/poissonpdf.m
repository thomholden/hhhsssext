function [px] = poissonpdf(x,lambda,logoption)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   [px] = poissonpdf (x,lambda,logoption)
%
%   computes Gamma propability density for x  given
%   scale matrix parameter beta and shape parameter alpha
%
%           
%         1                         x
%   p(x)= -- exp(-lambda x)  lambda
%         x!
%              
%
%
%   if logoption is set to one, the log-propability is returned
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin<3,
  logoption=0;
end;

if lambda<=0,
   error('lambda must be positive');
end;

if any(x<=0),
   error('Density only defined for positive x');
end;

x=x(:);
N=length(x);

normconst=log(exp(-lambda));

px=zeros(N,1);
px = x*log(lambda) - gammaln(x+1);

if logoption
  px=px+normconst;
else
  px=exp(px+normconst);
end;

