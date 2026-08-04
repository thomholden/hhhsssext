function [e, edata, eprior] = mlp2c_e(w, net, p, t)
%MLP2C_E	Evaluate error function for 2-layer softmax MLP.
%
%	Description
%	E = MLP2C_E(NET, P, T) takes a network data structure NET together
%	with a matrix P of input vectors and a matrix T of target vectors,
%	and evaluates the error function E. The choice of error funcion
%	corresponds to the output unit activation function. Each row of P
%	corresponds to one input vector and each row of T corresponds to one
%	target vector.
%
%	[E, EDATA, EPRIOR] = MLP2C_E(NET, P, T) also returns the data and
%	prior components of the total error.
%
%	See also
%	MLP2, MLP2PAK, MLP2UNPAK, MLP2FWD, MLP2BKP, MLP2C_G
%

% Copyright (c) 1996, 1997 Christopher M Bishop, Ian T Nabney
% Copyright (c) 1998, 1999 Aki Vehtari

net=mlp2unpak(net,w);

% Evaluate the data contribution to the error.
a = mlp2fwd(net, p);

% Ensure that sum(exp(a), 2) does not overflow
% Ensure that exp(a) > 0
maxcut = log(realmax) - log(net.nout);
mincut = log(realmin);
a = min(a, maxcut);
a = max(a, mincut);

temp = exp(a);
y = temp./(sum(temp, 2)*ones(1,net.nout));
% Ensure that log(y) is computable
y(y<realmin) = realmin;
edata = - sum(sum(t.*log(y)));

% Evaluate the prior contribution to the gradient.
eprior=0;
for pw=net.p.w
  pw=pw{:};
  eprior=eprior+feval([pw.f '_e'], w(pw.ii), pw.a);
end

e = edata + eprior;
