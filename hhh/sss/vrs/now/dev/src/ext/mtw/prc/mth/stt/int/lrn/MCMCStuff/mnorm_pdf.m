function y = mnorm_pdf(x,mu,sigma)
%MNORM_PDF Multivariate-Normal probability density function (pdf).
%
%   Description
%   Y = MNORM_PDF(X,MU,SIGMA) Returns the multivariate-normal
%   pdf with mean, MU, and covariance matrix, SIGMA, at the values in X.
%
%   Default values for MU and SIGMA are 0 and 1 respectively.

% Copyright (c) 1998-2005 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

if nargin < 3, 
  sigma = 1;
end

if nargin < 2;
  mu = 0;
end

if nargin < 1, 
  error('Requires at least one input argument.');
end

n=length(x);
x=x-mu;
y=-0.5*(sum(sum(inv(sigma).*(x'*x))) +log(det(sigma)) +log(2*pi)*n);
y=exp(y);
