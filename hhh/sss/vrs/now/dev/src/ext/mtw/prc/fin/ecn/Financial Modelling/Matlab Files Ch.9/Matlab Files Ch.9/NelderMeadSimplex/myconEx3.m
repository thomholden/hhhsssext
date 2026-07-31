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



function y = myconEx3(x)
% constraints function

% Four-Variable Example with an Equality Constraint
%--------------------------------------------------------
%               min f(x) = 2-x1*x2*x3
% subject to:      xi-1 <= 0 i=1,2,3
%                   -xi <= 0 i=1,2,3,4
%                  x4-2 <= 0
%                  x1+2*x2+2*x3-x4 == 0
%--------------------------------------------------------
y = zeros(9,1);
y(1:4) = -x;
y(5:7) = x(1:3,1)-1.0;
y(8) = x(4)-2;
y(9) = abs(x(1)+2*x(2)+2*x(3)-x(4))-1e-8;


end
