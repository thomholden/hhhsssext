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



function y = myconEx4(params)
% inequality constraints function

y = zeros(6,1);
y(1) = -params(1) - 10.0;
y(2) = params(1) - 10;
y(3) = -params(2) - 10.0;
y(4) = params(2) - 10;
y(5) = -params(1)*params(2) - 10.0;
% y(6) = params(1)*params(2) - params(1) - params(2) +1.5;
y(6) = abs(params(1) + params(2))-sqrt(eps);
end

