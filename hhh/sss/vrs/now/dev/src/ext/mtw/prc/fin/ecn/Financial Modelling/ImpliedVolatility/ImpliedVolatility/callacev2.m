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

function y = callacev2(S,K,T,beta,sigma,r)
% European Call for CEV model including zero rate
b = 2* beta;

if r == 0
    k = 2/(sigma^2*(2-b)^2*T);
else
    k = 2*r/(sigma^2*(2-b)*(exp(r*(2-b)*T)-1));
end
x = k*S^(2-b)*exp(r*(2-b)*T);
z = k * K.^(2-b);

y = max(S * (1-ncx2cdf(2*z,2+2/(2-b),2*x)) ...
    - K .* exp(-r*T).*ncx2cdf(2*x,2/(2-b),2*z),0);
end
