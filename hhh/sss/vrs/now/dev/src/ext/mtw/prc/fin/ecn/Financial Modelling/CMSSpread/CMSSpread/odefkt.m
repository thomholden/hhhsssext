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
% (C) Joerg Kienitz, Daniel Wetterau and Sven Glaser
%  
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 

function dy = odefkt(y,kappa,xi,mu,sigma,V)
% function used to determine average sigma
dy = [0;0];                                         % a column vector
dy(1) = - kappa * V * y(2);                         % gradient 1st coord
dy(2) = -kappa*y(2) -xi^2/2 * y(2)^2 + mu *sigma;   % gradient 2nd coord
end
