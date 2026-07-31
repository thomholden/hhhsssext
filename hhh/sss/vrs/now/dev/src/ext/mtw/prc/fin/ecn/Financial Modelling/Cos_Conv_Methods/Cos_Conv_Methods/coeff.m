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



function [chi, psi] = coeff(k, c, d, a, b)

chi = (exp(d)-exp(c));
psi = (d-c);

auxVar = double((b - a) ./ (k .* pi) ...
        .* ( sin(k .* pi .* (d - a) ./ (b - a)) - ...
        sin(k .* pi .* (c - a) ./ (b - a)) ));      

psi(2:end,:) = auxVar(2:end,:);
    
chi1 = 1 ./ ( 1 + ( k .* pi ./ (b - a) ) .^ 2 );
chi2 = exp(d) .* cos(k .* pi .* (d - a) ./ (b - a)) ...
        - exp(c) .* cos(k .* pi .* (c - a) ./ (b - a));
chi3 = k .* pi ./ (b - a) .* ... 
        ( exp(d) .* sin(k .* pi .* (d - a) ./ (b - a)) ...
        - exp(c) .* sin(k .* pi .* (c - a) ./ (b - a)) );

auxVar = chi1 .* (chi2 + chi3);

chi(2:end,:) = auxVar(2:end,:);

end