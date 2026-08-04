function [g, gdata, gprior] = mlp2b_g(w, net, p, t)
%MLP2B_G  Evaluate gradient of error function for 2-layer MLP with
%         logistic output actication function.
%
%	Description
%	G = MLP2B_G(NET, P, T) takes a network data structure NET  together
%	with a matrix P of input vectors and a matrix T of target vectors,
%	and evaluates the gradient G of the error function with respect to
%	the network weights. The error funcion corresponds to the choice of
%	output unit activation function. Each row of P corresponds to one
%	input vector and each row of T corresponds to one target vector.
%
%	[G, GDATA, GPRIOR] = MLP2B_G(NET, P, T) also returns separately  the
%	data and prior contributions to the gradient. In the case of multiple
%	groups in the prior, GPRIOR is a matrix with a row for each group and
%	a column for each weight parameter.
%
%	See also
%	MLP2, MLP2PAK, MLP2UNPAK, MLP2FWD, MLP2R_E, MLP2BKP
%

% Copyright (c) 1996,1997 Christopher M Bishop, Ian T Nabney
% Copyright (c) 1998,1999 Aki Vehtari

net=mlp2unpak(net,w);

% Evaluate the data contribution to the gradient.
[a, z] = mlp2fwd(net, p);
maxcut = -log(eps);
mincut = -log(1/realmin - 1);
a = min(a, maxcut);
a = max(a, mincut);
y = 1./(1 + exp(-a));
delout = y-t;

gdata = mlp2bkp(net, p, z, delout);

% Evaluate the prior contribution to the gradient.
gprior=zeros(size(w));
for pw=net.p.w
  pw=pw{:};
  gprior(pw.ii(:)) = feval([pw.f '_g'], w(pw.ii), pw.a);
end

g = gdata + gprior;
