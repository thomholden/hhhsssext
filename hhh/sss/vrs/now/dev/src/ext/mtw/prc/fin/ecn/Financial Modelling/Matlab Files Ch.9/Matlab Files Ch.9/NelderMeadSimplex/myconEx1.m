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



function y = myconEx1(params)
% inequality constraints function


% Nonconvex, Two-Variable Example
%--------------------------------------------------------
%               min f(x) = (x1-10)^3+(x2-20)^3
% subject to:      g1(x) = -x1+13 <= 0
%                  g2(x) = -(x1-5)^2-(x2-5)^2+100 <= 0
%                  g3(x) = (x1-6)^2+(x2-5)^2-82.81 <= 0
%                  g4(x) = -x2 <= 0
%--------------------------------------------------------
y = zeros(4,1);
y(1) = -params(1) + 13.0;
y(2) = -(params(1)-5)^2 -(params(2)-5)^2 + 100;
y(3) = (params(1)-6)^2 + (params(2)-5)^2 - 82.81;
y(4) = -params(2);

end

