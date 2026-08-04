function [ly, invC] = gpvalues(gp, tx, ty, invC)
%GPVALUES Sample latent values
%
%	Description
%	[LY, INVC] = GPVALUES(GP, TX, TY, INVC) takes a gp data structure 
%       GP together with a matrix TX of input vectors, matrix TY of target 
%       values and INVC (optional) inverse covariance matrix. Returns latent 
%       values LY and inverse of covariance matrix INVC. 
%
%	See also
%	GP2, GP2PAK, GP2UNPAK, GP2COV, GP2TRCOV
%

% Copyright (c) 2000 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.


%       For treatment of the method  see manual or 
%       Neal R. M. Regression and Classification Using Gaussian 
%       Process Priors, Bayesian Statistics 6.

% evaluate the variance matrix of tx. C is the covariance matrix 
% with noise added to diagonal elements. Cl is the covariance 
% matrix without noise.
[C,Cl]=gptrcov(gp, tx);

% Evaluate the inverse covariance matrix if it is not given 
% as input variable.
if nargin < 4
  L=inv(chol(C));
  invC=L*L'; 
end

% Evaluate the expected value of latent values
r=Cl'*invC;
y=r*ty;

% Evaluate the variance of latent values
lcov=Cl-r*Cl;
% make lcov symmetric, added 27.7.05 Jarno Vanhatalo
lcov=(lcov+lcov')/2;
% add "noise" to latent value samples
ly=y+chol(lcov)'*randn(size(y));
