function net = mlp2unpak(net, w)
%MLP2UNPAK Separates weights vector into weight and bias matrices. 
%
%	Description
%	NET = MLP2UNPAK(NET, W) takes an mlp network data structure NET and  a
%	weight vector W, and returns a network data structure identical to
%	the input network, except that the first-layer weight matrix W1, the
%	first-layer bias vector B1, the second-layer weight matrix W2 and the
%	second-layer bias vector B2 have all been set to the corresponding
%	elements of W.
%
%	See also
%	MLP2, MLP2PAK, MLP2FWD, MLP2B_CME, MLP2BKP, MLP2B_CMG
%

%	Copyright (c) 1996, 1997 Christopher M Bishop, Ian T Nabney
%       Copyright (c) 1998, 1999 Aki Vehtari      

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

if net.nwts ~= length(w)
  error('Invalid weight vector length')
end

nin = net.nin;
nhid = net.nhid;
nout = net.nout;

mark1 = nin*nhid;
net.w1 = reshape(w(1:mark1), nin, nhid);
mark2 = mark1 + nhid;
net.b1 = reshape(w(mark1 + 1: mark2), 1, nhid);
mark3 = mark2 + nhid*net.nout;
net.w2 = reshape(w(mark2 + 1: mark3), nhid, nout);
mark4 = mark3 + nout;
net.b2 = reshape(w(mark3 + 1: mark4), 1, nout);
