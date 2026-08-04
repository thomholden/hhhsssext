function [e, edata, eprior] = mlp2r_e(w, net, p, t)
%MLP2R_E	Evaluate error function for 2-layer network.
%
%	Description
%	E = MLP2R_E(W, NET, P, T) takes parameters W, a network
%	data structure NET together with a matrix P of input vectors 
%       and a matrix T of target vectors, and evaluates the error 
%       function E. The choice of error function corresponds to the
%       output unit activation function. Each column of P
%	corresponds to one input vector and each column of T corresponds to one
%	target vector.
%
%	[E, EDATA, EPRIOR] = MLP2R_E(W, NET, P, T) also returns the data and
%	prior components of the total error.
%
%	See also
%	MLP2, MLP2PAK, MLP2UNPAK, MLP2FWD, MLP2BKP, MLP2R_G
%

% Copyright (c) 1996, 1997 Christopher M Bishop, Ian T Nabney
% Copyright (c) 1998-2001 Aki Vehtari

% This software is distributed under the GNU General Public 
% License (version 2 or later); please refer to the file 
% License.txt, included with the software, for details.

%#function norme mnorme

net=mlp2unpak(net,w);

% Evaluate the residual contribution to the error. 
g = mlp2fwd(net, p);
r = g - t;

% evaluate the minus log from scaled N(0,p.r.a) distribution for the
% residual contribution r, i.e the likelihood error term.
pr=net.p.r;
edata=feval(pr.fe, r, pr.a);

% Evaluate the prior contribution to the error, and the prior error
% term.
eprior=0;
for pw=net.p.w
  pw=pw{:};
  eprior=eprior+feval(pw.fe, w(pw.ii), pw.a);
end

e = edata + eprior;
