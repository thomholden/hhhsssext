function [C,Cl]=gptrcov(gp, tx) 
% GPTRCOV     Evaluate covariance matrix of input vector.
%
%         Description
%         [C, CL] = GPTRCOV(GP, TX) takes in Gaussian process GP and 
%         matrix TX that contains input vectors to GP. Returns 
%         covariances of inputs in matrix CL and covariances of 
%         inputs with noise varainces added to diagonal elements in C.
%         Every element ij of C/CL contains covariance between inputs 
%         i and j in TX.
%
%         For covariance function definition see manual and 
%         Neal R. M. Regression and Classification Using Gaussian 
%         Process Priors, Bayesian Statistics 6.
%

% Copyright (c) 1998-2004 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

% Evaluate the number of inputs
n=size(tx,1);n1=n+1;

% Evaluate the covariance matrix for input vector
C=gpcov(gp, tx, tx);

% Add jitter to diagonal elements
C(1:n1:end)=C(1:n1:end)+gp.jitterSigmas.^2;
if nargout > 1
  Cl=C;
end
% If noise variances are given add them to diagonal elements
if ~isempty(gp.noiseVariances)
  C(1:n1:end)=C(1:n1:end)+gp.noiseVariances;
elseif ~isempty(gp.noiseSigmas)
  C(1:n1:end)=C(1:n1:end)+gp.noiseSigmas.^2;
end
