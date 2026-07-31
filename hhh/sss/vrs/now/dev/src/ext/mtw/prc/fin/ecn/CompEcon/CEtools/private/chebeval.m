% CHEBEVAL Evaluates Chebyshev polynomial approximations
% USAGE
%   y=chebeval(c,x,n,a,b);
% INPUTS
%   c : N x p matrix
%   x : m x d matrix
%   n : d vector of integers with prod(n)=N
%   a : d vector of lower bounds
%   b : d vector of upper bounds
% OUTPUT
%   y : m x p matrix
%
% Uses Clenshaw recursion and is coded as a MEX file for speed

% Copyright (c) 1997-2006, Paul L. Fackler & Mario J. Miranda
% paul_fackler@ncsu.edu, miranda.4@osu.edu

function y=chebeval(c,x,n,a,b)

disp('If you get this message, you have not correctly installed the CompEcon Toolbox')
disp('Please read the README file for installation details, epsecially the section concerning MEX files')
error(' ')

return

% Algorithm used by MEX file is close to the following:

  p=size(c,2);
  [m,d]=size(x);

  N=prod(n);
  if size(c,1)~=N
    error('c has improper number of rows');
  end

  y=zeros(m,p);

  cind=zeros(1,d);  
  cind(d)=p; for i=d-1:-1:1, cind(i)=cind(i+1)*n(i+1); end

  for xrows=1:m
    cc=c;
    for j=1:d
      z=(2*x(xrows,j)-a(j)-b(j))/(b(j)-a(j));
      z2=z*2;
      cc=reshape(cc(1:n(j)*cind(j)),n(j),cind(j));
      for k=1:cind(j)
        di=0; 
        dd=0;
        for i=n(j):-1:2
          temp=di;
          di=z2*di-dd+cc(i,k);
          dd=temp;
        end
        cc(k)=z*di-dd+cc(1,k);
      end
    end
    for i=1:p, y(xrows,i)=cc(i); end
  end