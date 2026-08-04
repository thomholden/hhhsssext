function net = mlp2(type, nin, nhid, nout)
%MLP2	Create a 2-layer feedforward network without activation
%       function.
%
%	Description
%	NET = MLP2(TYPE, NIN, NHID, NOUT) takes the number of inputs,
%	hidden units and output units for a 2-layer feed-forward network
%	together with a string TYPE which specifies the network type,
%       and returns a data structure NET. The weights are set to zero.
%       The hidden units use the TANH activation function.
%
%	The fields in NET are
%	  type = 'mlp2'
%	  nin  = number of inputs
%	  nhid = number of hidden units
%	  nout = number of outputs
%	  nwts = total number of weights and biases
%	  w1   = first-layer weight matrix
%	  b1   = first-layer bias vector
%	  w2   = second-layer weight matrix
%	  b2   = second-layer bias vector
%	 Here W1 has dimensions NIN times NHID, B1 has dimensions 1 times
%	NHID, W2 has dimensions NHID times NOUT, and B2 has dimensions
%	1 times NOUT.
%
%	See also
%	MLP2PAK, MLP2UNPAK, MLP2FWD, MLP2B_CME, MLP2BKP, MLP2B_CMG
%

% Copyright (c) 1996,1997 Christopher M Bishop, Ian T Nabney
% Copyright (c) 1998,1999 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.


net.type = type;
net.nin = nin;
net.nhid = nhid;
net.nout = nout;
net.nwts = (nin + 1)*nhid + (nhid + 1)*nout;

net.w1 = zeros(nin, nhid);
net.b1 = zeros(1, nhid);
net.w2 = zeros(nhid, nout);
net.b2 = zeros(1, nout);
