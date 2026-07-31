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



function [chi, psi] = coeff_b(k, x1, x2, a, b)
% compute chi and psi for cosine method
NStrikes = size(k,1);                       % fix size

chi = ones(NStrikes,1) * (exp(x2)-exp(x1)); % init chi
psi = ones(NStrikes,1) * (x2-x1);           % init psi

k2 = k(2:end);

arg2 = k2 .* pi .* (x2 - a) ./ (b - a);     % arg trig func
arg1 = k2 .* pi .* (x1 - a) ./ (b - a);     % arg trig func

term1 = exp(x2) .* cos( arg2 );
term2 = exp(x1) .* cos( arg1 );

term3 = exp(x2) .* k2 .* pi ./ (b-a) .* sin( arg2 );
term4 = exp(x1) .* k2 .* pi ./ (b-a) .* sin( arg1 );

chi(2:end) = 1 ./ ( 1 + ((k2 .* pi) ./ (b - a)).^2 ) ...
    .* ( term1 - term2 + term3 - term4 );   % modify init

arg2 = k2 .* pi .* (x2 - a) ./ (b - a);     % arg trig func
arg1 = k2 .* pi .* (x1 - a) ./ (b - a);     % arg trig func
    
psi(2:end) = (b - a) ./ (k2 .* pi) ...
    .* ( sin(arg2) - sin(arg1) );           % modify init

end
