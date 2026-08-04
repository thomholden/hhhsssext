function w = mlp2pak(net)
%MLP2PAK	Combines weights and biases into one weights vector.
%
%	Description
%	W = MLPPAK(NET) takes a network data structure NET and combines the
%	components of weight matrices and bias vectors into a
%	single row vector W.
%
%	The facility to switch between these two representations for the
%	network parameters is useful, for example, in training a network by
%	error function minimization, since a single vector of parameters can
%	be handled by general-purpose optimization routines.
%
%	The ordering of the parameters in W is defined by
%	  w = [net.w1(:)', net.b1, net.w2(:)', net.b2];
%	 where W1 is the first-layer weight matrix, B1 is the first-layer
%	bias vector, W2 is the second-layer weight matrix, and B2 is the
%	second-layer bias vector.
%
%	See also
%	MLP, MLPUNPAK, MLPFWD, MLPERR, MLPBKP, MLPGRAD
%

% Copyright (c) 1996, 1997 Christopher M Bishop, Ian T Nabney

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

w = [net.w1(:)', net.b1, net.w2(:)', net.b2];
