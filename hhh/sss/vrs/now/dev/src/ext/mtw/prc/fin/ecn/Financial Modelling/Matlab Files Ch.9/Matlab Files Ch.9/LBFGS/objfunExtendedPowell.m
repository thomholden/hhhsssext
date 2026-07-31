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



function [f,g] = objfunExtendedPowell(x)

% Example: Extended Powell Function, N variable but a multiple of 4
%-------------------------------------------------------------------
% min f(x) = (x1 + 10x2)^2 + 5(x3 - x4)^2 + (x2 - 2x3)^4 + 10(x1 - x4)^4
%          + ...
%          + (x(N-3) + 10x(N-2))^2 + 5(x(N-1) - x(N))^2 
%                + (x(N-2) - 2x(N-1))^4 + 10(x(N-3) - x(N))^4
%
% Global minimum f(x*) = 0 with x* = (0,...,0)'
%-------------------------------------------------------------------

N = length(x);

aux1 = x(1:4:N-3) + 10*x(2:4:N-2);
aux2 = x(3:4:N-1) - x(4:4:N);
aux3 = x(2:4:N-2)-2*x(3:4:N-1);
aux4 = x(1:4:N-3) - x(4:4:N);

% objective function
f = sum(aux1.^2 + 5*aux2.^2 + aux3.^4 + 10*aux4.^4);

% gradient
if(nargout > 1)
   g =  zeros(N,1);
   g(1:4:N-3) = 2*aux1 + 40*aux4.^3;
   g(2:4:N-2) = 20*aux1 + 4*aux3.^3;
   g(3:4:N-1) = 10*aux2 - 8*aux3.^3;
   g(4:4:N) = -10*aux2 - 40*aux4.^3;
end