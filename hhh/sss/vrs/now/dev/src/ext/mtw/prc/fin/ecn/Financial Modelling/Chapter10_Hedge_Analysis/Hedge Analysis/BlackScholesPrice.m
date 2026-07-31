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
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [value,delta,gamma,vega] = BlackScholesPrice(S,K,r,T,sigma)

% one-dimensional Black & Scholes formula and Greeks

d1 = (log(S/K) + (r + 1/2 *sigma*sigma) * T)/(sigma * sqrt(T));
d2 = (log(S/K)+ (r - 1/2 *sigma*sigma) * T)/(sigma * sqrt(T));

value = S * normcdf(d1) - K * exp(-r*T) * normcdf(d2);
delta = normcdf(d1);
gamma = normpdf(d1) / (S*sigma*sqrt(T));
vega = S * normpdf(d1)*sqrt(T);
end