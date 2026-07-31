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



function y = levymvg(x,sigma,nu,theta)
    C = 1/nu;
    G = 1/(sqrt(0.25 * theta^2*nu^2 + 0.5* sigma^2)-0.5*theta*nu);
    M = 1/(sqrt(0.25 * theta^2*nu^2 + 0.5* sigma^2)+0.5*theta*nu);
    y = x;
    y(x<0) = C  *exp( G*x(x<0)) ./ abs(x(x<0));
    y(x>0) = C * exp(-M*x(x>0)) ./ x(x>0);
    y(x==0) = 0;
end