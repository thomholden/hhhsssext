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



function [g,Jacg,h,Jach] = constraintsFunctionExample3(x)
%This function defines the constraints functions g and h
%of the constrained optimization problem and their Jacobian matrices
%
% min f(x) according to g(x) <= 0, h(x) = 0
%
% Rosen-Suzuki-Problem: Convex, Four-Variable Example
%--------------------------------------------------------
%               min f(x) = x1^2+x2^2+2*x3^2+x4^2-5*x1-5*x2-21*x3+7*x4
% subject to:      g1(x) = x1^2+x2^2+x3^2+x4^2+x1-x2+x3-x4-8 <= 0
%                  g2(x) = x1^2+2*x2^2+x3^2+2*x4^2-x1-x4-10 <= 0
%                  g3(x) = 2*x1^2+x2^2+x3^2+2*x1-x2-x4-5 <= 0
%--------------------------------------------------------
g = zeros(3,1);
g(1) = x(1)^2+x(2)^2+x(3)^2+x(4)^2+x(1)-x(2)+x(3)-x(4)-8.0;
g(2) = x(1)^2+2*x(2)^2+x(3)^2+2*x(4)^2-x(1)-x(4)-10;
g(3) = 2*x(1)^2+x(2)^2+x(3)^2+2*x(1)-x(2)-x(4)-5;


Jacg = zeros(3,4);
Jacg(1,1) = 2*x(1)+1;
Jacg(1,2) = 2*x(2)-1;
Jacg(1,3) = 2*x(3)+1;
Jacg(1,4) = 2*x(4)-1;
Jacg(2,1) = 2*x(1)-1;
Jacg(2,2) = 4*x(2);
Jacg(2,3) = 2*x(3);
Jacg(2,4) = 4*x(4)-1;
Jacg(3,1) = 4*x(1)+2;
Jacg(3,2) = 2*x(2)-1;
Jacg(3,3) = 2*x(3);
Jacg(3,4) = -1;

h = [];

Jach = [];

end

% function [g,h] = constraintsFunctionExample3(x)
% 
% g = zeros(3,1);
% g(1) = x(1)^2+x(2)^2+x(3)^2+x(4)^2+x(1)-x(2)+x(3)-x(4)-8.0;
% g(2) = x(1)^2+2*x(2)^2+x(3)^2+2*x(4)^2-x(1)-x(4)-10;
% g(3) = 2*x(1)^2+x(2)^2+x(3)^2+2*x(1)-x(2)-x(4)-5;
% 
% h = [];
% 
% end