function y = mlp2b_sim(net, x)
%MLP2B_SIM Simulate a 2-layer binary logistic regression feedforward network
%
%	Description
%	Y = MLP2B_SIM(NET, X) takes a network data structure NET together
%       with a matrix X of input vectors, and calculates output.
%
%	See also
%	MLP2, MLP2PAK, MLP2UNPAK, MLP2ERR, MLP2BKP, MLP2GRAD
%

% Copyright (c) 1999 Aki Vehtari

a=mlp2fwd(net,x);
y = 1./(1 + exp(-a));
