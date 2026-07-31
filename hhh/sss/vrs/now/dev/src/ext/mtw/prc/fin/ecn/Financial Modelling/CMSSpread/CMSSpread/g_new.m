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

function fval = g_new( u,v,betaQuer1,betaQuer2, sigmaTilde1, sigmaTilde2, ...
    muTilde1,muTilde2, rhoQuer, S1,S2, KTilde, w)
%Implements the function g(u,v)

KHut = exp((muTilde2-.5*sigmaTilde2^2)*v+sigmaTilde2*sqrt(v).*u + log(S2) ...
    - log(betaQuer2)) + KTilde;
h = (muTilde1-.5*rhoQuer^2*sigmaTilde1^2)*v ...
    + rhoQuer*sigmaTilde1*sqrt(v).*u;

fval = zeros(size(KHut));

arg1 = w*(log(S1./(betaQuer1*KHut(KHut > 0))) + h(KHut > 0) ...
    + .5*sigmaTilde1^2*(1-rhoQuer^2).*v(KHut > 0)) ...
    ./(sigmaTilde1*sqrt(v(KHut > 0)*(1-rhoQuer^2)));
arg2 = arg1 - w*sigmaTilde1*sqrt(v(KHut > 0)*(1-rhoQuer^2));

fval(KHut > 0) = w*(S1*exp(h(KHut > 0)).*normcdf(arg1)/betaQuer1 ...
    - KHut(KHut > 0).*normcdf(arg2));
if w == 1
    fval(KHut <= 0) = (S1/betaQuer1 .* exp(h(KHut <= 0))-KHut(KHut <= 0));
end
fval = fval.*exp(-.5*u.^2);

end



