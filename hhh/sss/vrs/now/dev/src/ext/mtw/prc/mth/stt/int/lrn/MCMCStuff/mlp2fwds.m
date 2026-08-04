function [y, z] = mlp2fwds(net, x)
%MLP2FWDS	Forward propagation through 2-layer networks with
%               linear output activation function.
%
%   Description
%   Y = MLP2FWDS(NET, X) takes networks data structures NET together with a
%   matrix X of input vectors, and forward propagates the inputs through
%   the networks to generate a MxNxP matrix Y of output vectors, where M is the
%   length of X, N is the number of outputs and P is the number of networks. 
%   Each column of X   corresponds to one input vector and each column of Y 
%   corresponds to one output vector.
%
%   [Y, Z] = MLPFWDS(NET, X) also generates a matrix Z of the hidden unit
%   activations where each row corresponds to one pattern.
%
%   See also
%   MLP2, MLP2PAK, MLP2UNPAK, MLP2R_E, MLP2R_G, MLP2FWD
%

% Copyright (c) 1996,1997 Christopher M Bishop, Ian T Nabney
% Copyright (c) 1999 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

W1=net.inputWeights;
B1=net.inputBiases;
W2=net.layerWeights{1};
B2=net.layerBiases{1};

nin=net.numInputs;
nhid=net.numHidden;
nout=net.numOutputs;
[m,n]=size(W1);
ndata = size(x,1);
z=[];
y=[];

for i=1:m
  net.w1=reshape(W1(i,:),nhid,nin)';
  net.b1=B1(i,:);
  net.w2=reshape(W2(i,:),nout,nhid)';
  net.b2=B2(i,:);
  y(:,:,i)=mlp2fwd(net,x);
end
