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



function [delta,gamma] = GreeksFD(pricer,model,S,K,T,r,d)

e = 0.0001;

[priceUp, deltaUp] = pricer.PriceAndGreeks(model,S+e,K,T,r,d);
[priceDn, deltaDn] = pricer.PriceAndGreeks(model,S-e,K,T,r,d);

delta = (priceUp - priceDn)/(2 * e);
gamma = (deltaUp - deltaDn)/(2 * e);

end