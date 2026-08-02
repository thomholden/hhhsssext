function [f] = gauss (x,m,d)

% function [f] = gauss (x,m,d)
% Return gaussian function
% x	where function is evaluated
% m 	'mean' parameter of function
% d	'deviation' parameter of function

var = d^2;
f = -1 *(x - m).^2;
f = f./ (2*var);
f = exp (f);
f = f./ sqrt (2*pi*var);
