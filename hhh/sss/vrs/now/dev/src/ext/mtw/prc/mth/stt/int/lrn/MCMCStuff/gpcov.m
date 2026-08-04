function C=gpcov(gp, x1, x2)
% GPCOV     Evaluate covariance matrix between two input vectors. 
%
%         Description
%         C = GPCOV(GP, TX, X) takes in Gaussian process GP and two
%         matrixes TX and X that contain input vectors to GP. Returns 
%         covariance matrix C. Every element ij of C contains covariance 
%         between inputs i in TX and j in X.
%
%         For covariance function definition see manual or 
%         Neal R. M. Regression and Classification Using Gaussian 
%         Process Priors, Bayesian Statistics 6.

% Copyright (c) 1998-2004 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

if isempty(x2)
  x2=x1;
end
C=0;
% add the constant part to the covariance
if ~isempty(gp.constSigmas)
  C=C+gp.constSigmas.^2;
end
%if ~isempty(gp.linearSigmas)
%  C=C+sum(gtimes(permute(gtimes(gp.linearSigmas(ii).^2,x1),[1 3 2]),...
%		 permute(x2,[3 1 2])),3);
%end

% Evaluate the covariance
if ~isempty(gp.expScale)
  C=C+gp.expScale.^2.*exp(-wdist2(gp.expSigmas.^2,x1,x2));
end
C(C<eps)=0;
