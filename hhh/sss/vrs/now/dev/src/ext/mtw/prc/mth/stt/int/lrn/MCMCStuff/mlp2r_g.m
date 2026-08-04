function [g, gdata, gprior] = mlp2r_g(w, net, p, t)
%MLP2R_G Evaluate gradient of error function for 2-layer network.
%
%	Description
%	G = MLP2R_G(NET, P, T) takes a network data structure NET  together
%	with a matrix P of input vectors and a matrix T of target vectors,
%	and evaluates the gradient G of the error function with respect to
%	the network weights. The error function corresponds to the choice of
%	output unit activation function. Each row of P corresponds to one
%	input vector and each row of T corresponds to one target vector.
%
%	[G, GDATA, GPRIOR] = MLP2R_G(NET, P, T) also returns separately  the
%	data and prior contributions to the gradient. In the case of multiple
%	groups in the prior, GPRIOR is a matrix with a row for each group and
%	a column for each weight parameter.
%
%	See also
%	MLP2, MLP2PAK, MLP2UNPAK, MLP2FWD, MLP2R_E, MLP2BKP
%

% Copyright (c) 1996,1997 Christopher M Bishop, Ian T Nabney
% Copyright (c) 1998-2001 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

%#function normg mnormg

net=mlp2unpak(net,w);

% Evaluate the data contribution to the gradient.
[y, z] = mlp2fwd(net, p);
r = y - t;

pr=net.p.r;
gr=feval(pr.fg, r, pr.a);

gdata = mlp2bkp(net, p, z, gr);

% Evaluate the prior contribution to the gradient.
gprior=zeros(size(w));
for pw=net.p.w
  pw=pw{:};ii=pw.ii;
  gprior(ii(:)) = feval(pw.fg, w(ii), pw.a);
end

g = gdata + gprior;
