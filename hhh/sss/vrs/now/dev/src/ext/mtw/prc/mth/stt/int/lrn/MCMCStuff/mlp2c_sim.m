function y = mlp2c_sim(net, x)
%MLP2C_SIM     Simulate a 2-layer softmax regression feedforward network
%
%	Description
%	Y = MLP2C_SIM(NET, X) takes a network data structure NET together
%       with a matrix X of input vectors, and calculates output.
%
%	See also
%	MLP2, MLP2PAK, MLP2UNPAK, MLP2ERR, MLP2BKP, MLP2GRAD
%

% Copyright (c) 1999 Aki Vehtari

a=mlp2fwd(net,x);

temp = exp(a);
y = temp./(sum(temp, 2)*ones(1,net.nout));
