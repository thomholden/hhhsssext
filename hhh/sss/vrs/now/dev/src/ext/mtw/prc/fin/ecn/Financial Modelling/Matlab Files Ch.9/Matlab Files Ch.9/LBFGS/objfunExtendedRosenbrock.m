% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [f,g] = objfunExtendedRosenbrock(x)

% Example: Extended Rosenbrock Function, N variable but even
%--------------------------------------------------------
%     min f(x) = 100(x2 - x1^2)^2 + (1 - x1)^2
%               + 100(x4 - x3^2)^2 + (1 - x3)^2
%               + ...
%               + 100(xN - x_N-1^2)^2 + (1 - x_N-1)^2
%
% Global minimum f(x*) = 0 with x* = (1,...,1)'
%--------------------------------------------------------

N = length(x);

% objective function
f = sum(100*(x(2:2:N) - x(1:2:N-1).^2).^2 ...
           + (1 - x(1:2:N-1)).^2);

% gradient
if(nargout > 1)
   g =  zeros(N,1);
   g(1:2:N-1) = 400*x(1:2:N-1).*(x(1:2:N-1).^2 - x(2:2:N)) + 2*(x(1:2:N-1) - 1);
   g(2:2:N) = 200*(x(2:2:N) - x(1:2:N-1).^2);
end