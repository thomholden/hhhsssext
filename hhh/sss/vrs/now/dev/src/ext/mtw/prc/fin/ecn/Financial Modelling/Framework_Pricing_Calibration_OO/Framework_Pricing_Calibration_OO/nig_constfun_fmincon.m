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



function [c, ceq] = nig_constfun_fmincon(x,model,varargin)

I = model.usevec == true;

p = model.parvec;
p(I) = x;

%inequality constraints vector
c_p  = [-p(1); -(p(1)+p(2)); p(2)-p(1); -p(3)];
c = c_p(I);
%equality constraints vector
ceq = [];
end