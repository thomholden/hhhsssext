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



function y = mycon(x)
% auxiliaray variables
v1 = 2*x(1)^2;
v2 = x(2)^2;
% Constraints
y = zeros(1,4);
y(1,1) = v1 + 3*v2^2 + x(3) + 4*x(4)^2 + 5*x(5) - 127;
y(1,2) = 7*x(1) + 3*x(2) + 10*x(3)^2 + x(4) - x(5) - 282;
y(1,3) = 23*x(1) + v2 + 6*x(6)^2 - 8*x(7) - 196;
y(1,4) = 2*v1 + v2 - 3*x(1)*x(2) + 2*x(3)^2 + 5*x(6) - 11*x(7);
 