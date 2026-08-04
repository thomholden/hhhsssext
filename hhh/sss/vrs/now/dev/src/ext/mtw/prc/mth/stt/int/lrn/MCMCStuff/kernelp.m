function [p,xx]=kernelp(x,xx)
%KERNELP      Kernel density estimator for one dimensional distribution.
%
%         Description
%         [P, XX] = KERNELP(X ,XX) takes samples X from one dimensional 
%         distribution and points XX, where the density is wanted to 
%         estimate and returns the density estimate P at points XX.

%   Author: Aki Vehtari <Aki.Vehtari@hut.fi>
%   Last modified: 2004-09-07 10:59:05 EEST

% Copyright (c) 1998-2004 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

if nargin < 2
  n=200;
  xa=min(x);xb=max(x);xd=xb-xa;
  xa=xa-xd/20;xb=xb+xd/20;xx=linspace(xa,xb,n);
end
m=length(x)/2;
stdx=std(x);
xd=gminus(x(1:m),x(m+1:end)');
ef=str2func('err');
sh=fminbnd(ef,stdx/5,stdx*20,[],xd);
p=mean(exp(norm_lpdf(gminus(x(1:m),xx),0,sh)));



function e=err(s,xd)
e=-sum(log(sum(normpdf(xd,0,s))));

function y = normpdf(x,mu,sigma)
y = -0.5 * ((x-mu)./sigma).^2 -log(sigma) -log(2*pi)/2;
y=exp(y);

function y=gminus(x1,x2)
%GMINUS   Generalized minus.
y=genop(@minus,x1,x2);

function y=genop(f,x1,x2)
% GENOP - Generalized operation
%   
%   C = GENOP(F,A,B) Call function F with exapanded matrices Y and X.
%   The dimensions of the two operands are compared and singleton
%   dimensions in one are copied to match the size of the other.
%   Returns a matrix having dimension lengths equal to
%   MAX(SIZE(A),SIZE(B))
%
% See also GENOPS

% Copyright (C) 2003 Aki Vehtari
%
% This software is distributed under the GNU General Public 
% Licence (version 2 or later); please refer to the file 
% Licence.txt, included with the software, for details.

s1=size(x1);
s2=size(x2);
ls1=numel(s1);
ls2=numel(s2);
l=max(ls1,ls2);
d=ls1-ls2;
if d<0
  s1(ls1+1:ls1+d)=1;
elseif d>0
  s2(ls2+1:ls2+d)=1;
end
if any(s1>1 & s2>1 & s1~=s2)
  error('Array dimensions are not appropriate.');
end
r1=ones(1,l);
r2=r1;
r1(s1==1)=s2(s1==1);
r2(s2==1)=s1(s2==1);
y=feval(f,repmat(x1,r1),repmat(x2,r2));
