function g = mlp2deriv(net, x)
%MLP2DERIV Evaluate derivatives of MLP outputs with respect to weights.
%
%	Description
%	G = MLP2DERIV(NET, X) takes a network data structure NET and a matrix
%	of input vectors X and returns a three-index matrix G whose I, J, K
%	element contains the derivative of network output K with respect to
%	weight or bias parameter J for input pattern I. The ordering of the
%	weight and bias parameters is defined by MLP2UNPAK.
%
%	See also
%	MLP2, MLP2PAK, MLP2BKP
%

%	Copyright (c) Ian T Nabney, Christopher M Bishop (1996, 1997, 1998)

[y, z] = mlp2fwd(net, x);

ndata = size(x, 1);

g = zeros(ndata, net.nwts, net.nout);
for k = 1 : net.nout
  delta = zeros(1, net.nout);
  delta(1, k) = 1;
  for n = 1 : ndata
    g(n, :, k) = mlp2bkp(net, x(n, :), z(n, :), delta);
  end
end
