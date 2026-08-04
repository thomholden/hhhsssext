function y = tanh_f(x)
%TANH_F   Faster hyperbolic tangent.
%
%   TANH_F(X) is the hyperbolic tangent of the elements of X.

% Copyright (c) 1999 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

% In case mex-file is not available, fall back to built-in tanh
%#external
y=tanh(x);
