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



function value = BlackScholesPaths(S, mu, T, nPaths, nSims, sigma)

stock = zeros(nPaths,nSims);
stock(1,:) = S;
dW = randn(nPaths,nSims);
dt = T/nPaths;
for i=2:nPaths
    stock(i,:) = stock(i-1,:) .* exp((mu - 1/2 * sigma * sigma) * dt...
                 + sigma * sqrt(dt) .* dW(i-1,:));
end
value = stock;
end