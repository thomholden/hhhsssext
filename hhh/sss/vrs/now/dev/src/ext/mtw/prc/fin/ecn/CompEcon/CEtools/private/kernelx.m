% KERNELX Used by KERNEL
% A C-Mex file version of this exists.
% Use MEX KERNELX.C to create if one does not exist

% Copyright (c) 1997-2001, Paul L. Fackler & Mario J. Miranda
% paul_fackler@ncsu.edu, miranda.4@osu.edu

function f=kernelx(x,xi,h,ktype)

warning('The MEX implementation of this function should be used')

m=size(xi,1);
n=size(x);
N=prod(n);
x=x(:)';

if h(1)==0
  h=m.^(-0.2);
  switch ktype
    case 1,  h=1.0487*h;
    case 0,  h=1.0592*h;
    otherwise
      error('Invalid kernel type')
  end
end

h=std(xi)*h+zeros(m,1);
k=(x(ones(m,1),:)-xi(:,ones(N,1)))./h(:,ones(N,1));
switch ktype
  case 1 
    k=(.15/sqrt(5))*max(5-k.^2,0)./h(:,ones(N,1));
  case 0
    k=(1/sqrt(2*pi))*exp(-0.5*k.^2)./h(:,ones(N,1));
end
f=reshape(mean(k),n);
