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



function prices = FFTCallCorrector(prices)

n = length(prices);
i = 2;
while (prices(i) < prices(i-1) && prices(i) > 0) && i < n
 i = i+1;  
end
prices = prices(1:i-1);
m = n-i+1;
dn = prices(i-1)/m;
addPrices = prices(i-1)-dn:-dn:0;
prices = [prices;addPrices'];

if length(prices) < n
   prices = [prices;zeros(1,n-length(prices))'];
elseif length(prices) > n
    prices = prices(1:n);
else
    
end
end