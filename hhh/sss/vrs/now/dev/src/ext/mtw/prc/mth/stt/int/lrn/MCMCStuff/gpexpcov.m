function c = gpexpcov(gp, tx, x)
% GPEXPCOV     Evaluate covariance matrix.
%
%         Description
%         C = GPEXPCOV(GP, TX, X) takes in Gaussian process GP and two
%         matrixes TX and X that contain input vectors to GP. Returns 
%         covariance matrix C. Every element ij of C contains covariance 
%         between inputs i in TX and j in X.
%

% Copyright 1998-2004 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

error('No mex-file for this architecture. See Matlab help and convert.m in ./linuxCsource or ./winCsource for help.')
