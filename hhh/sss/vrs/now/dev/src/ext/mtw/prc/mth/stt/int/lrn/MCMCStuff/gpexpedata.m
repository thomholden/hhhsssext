function e = gpexpedata(gp, p, t)
%GPEXPEDATA     Evaluate error function for gp.
%
%	Description
%	E = GPEXPEDATA(GP, P, T) takes a gp data structure GP together
%	with a matrix P of input vectors and a matrix T of target vectors,
%	and evaluates the error function E. The choice of error function
%	corresponds to the output unit activation function. Each row of P
%	corresponds to one input vector and each row of T corresponds to one
%	target vector.
%
%	See also
%	GP2, GP2PAK, GP2UNPAK, GP2FWD, GP2R_G
%

% Copyright (c) 1998-2004 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.
error('No mex-file for this architecture. See Matlab help and convert.m in ./linuxCsource or ./winCsource for help.')
