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

function y = callacev(S,K,T,t,beta,sigma)
% European Call price for CEV model
% S0 = S * size(K,1);
nu = 1/(2*(1-beta));
var = (T-t)*sigma^2;
d1 = 4*nu^2/var*S.^(1/nu);
d2 = 4*nu^2/var*K.^(1/nu);
y = S .*(1-ncx2cdf(d2,2*nu+2,d1)) ...
    - K .* ncx2cdf(d1,2*nu,d2);
y = max(y,0);
end

