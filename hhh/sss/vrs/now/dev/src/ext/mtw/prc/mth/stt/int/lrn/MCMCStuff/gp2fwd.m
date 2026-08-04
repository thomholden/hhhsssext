function y = gp2fwd(gp, tx, ty, x, invC)
%GP2FWD	Forward propagation through Gaussian Process
%
%	Description
%	Y = GP2FWD(GP, TX, TY, X) takes a gp data structure GP together with a
%	matrix X of input vectors, Matrix TX of training inputs and vectpr TY of 
%       training targets, and forward propagates the inputs through the gp to generate 
%       a matrix Y of output vectors. Each row of X corresponds to one input 
%       vector and each row of Y corresponds to one output vector.
%
%       BUGS: - only exp2 covariance function is supported
%             - only 1 output allowed
%             - only mean values
%
%	See also
%	GP2, GP2PAK, GP2UNPAK
%

% Copyright (c) 2000 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

K=gpcov(gp,tx,x);

if nargin > 4
  y=K'*(invC*ty);
else
  n=size(x,1);
  C=gptrcov(gp,tx);
  
  y=K'*(C\ty);
end
