function [InvC c cc]  = gpexptrcovinv(gp, tx)
% GPEXPTRCOVINV     Evaluate inverse of covariance matrix.
%
%         Description
%         INVC = GPEXPTRCOVINV(GP, TX) takes in Gaussian process GP and 
%         matrix TX that contains input vectors to GP. Returns inverse of
%         covariance matrix C. Every element ij of C contains covariance 
%         between inputs i and j in TX.
%
%         [INVC, C, CC] = GPEXPTRCOVINV(GP, TX) returns also matrices CC 
%         and CC. 
%
%         Matrix C contains elements that are used in evaluation of 
%         derivative of log likelihood with respect to expScale 
%         d(Cov)/d(expScale) = 2*C, where Cov is the covariance function.
%         
%         CC is three dimensional matrix containing elements that 
%         are used in evaluation of derivative of log likelihood with respect 
%         to expSigmas. d(Cov)/d(expSigmas_i) = -2.*CC(:,:,i).*C, where 
%         expSigmas_i is the expSigma for input i.


% Copyright (c) 1998-2004 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

error('No mex-file for this architecture. See Matlab help and convert.m in ./linuxCsource or ./winCsource for help.')
