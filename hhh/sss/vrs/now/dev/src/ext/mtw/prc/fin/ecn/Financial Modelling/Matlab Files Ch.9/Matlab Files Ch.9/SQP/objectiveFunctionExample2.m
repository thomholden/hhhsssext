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



function y = objectiveFunctionExample2(xvec)
%This function defines the objective function to minimize
%f(x1,x2) = exp(x1)*[4x1^2+2x2^2+4x1x2+2x1+1]

y = exp(xvec(1))*(4*xvec(1)^2+2*xvec(2)^2+4*xvec(1)*xvec(2)+2*xvec(1)+1);

end

