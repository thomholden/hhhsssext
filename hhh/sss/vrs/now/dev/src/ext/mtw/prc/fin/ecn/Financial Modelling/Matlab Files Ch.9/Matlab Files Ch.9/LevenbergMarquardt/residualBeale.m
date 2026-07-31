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



function [R,JacR] = residualBeale(x,sqr2)
% This function implements the residual vector R(x)
% and the Jacobian matrix JacR(x) for x = (x1,x2)',
% such that 
% f(x1,x2) = 0.5*R(x)'R(x)
% is satisfied for the Beale function
% f(x1,x2) = (1.5 - x1*(1 - x2))^2 + (2.25 - x1*(1 - x2^2))^2
%           + (2.625 - x1*(1 - x2^3))^2

% residual vector
R = sqr2*[
          1.5+x(1)*(x(2)-1);
          2.25+x(1)*(x(2)^2-1); 
          2.625+x(1)*(x(2)^3-1)
         ];

% jacobian matrix
JacR = sqr2*[
             x(2)-1, x(1);
             x(2)^2-1, 2*x(1)*x(2);
             x(2)^3-1, 3*x(1)*x(2)^2
            ];