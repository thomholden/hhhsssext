function [y, z] = mlp2fwd(net, x)
%MLP2FWD	Forward propagation through 2-layer network with
%               linear output activation function.
%
%	Description
%	Y = MLP2FWD(NET, X) takes a network data structure NET together with a
%	matrix X of input vectors, and forward propagates the inputs through
%	the network to generate a matrix Y of output vectors. Each column of X
%	corresponds to one input vector and each column of Y corresponds to one
%	output vector.
%
%	[Y, Z] = MLPFWD(NET, X) also generates a matrix Z of the hidden unit
%	activations where each row corresponds to one pattern.
%
%	See also
%	MLP2, MLP2PAK, MLP2UNPAK, MLP2R_E, MLP2R_G
%

% Copyright (c) 1996,1997 Christopher M Bishop, Ian T Nabney

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

ndata = size(x, 1);
z = tanh_f(x*net.w1 + ones(ndata, 1)*net.b1);
y = z*net.w2 + ones(ndata, 1)*net.b2;
