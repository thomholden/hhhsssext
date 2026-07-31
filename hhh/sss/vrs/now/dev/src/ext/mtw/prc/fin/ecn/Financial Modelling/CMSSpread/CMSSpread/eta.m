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

function [out]=eta(mu,kappa,xi,T,V)
% the log Laplace transform of density f
    gamma=sqrt(kappa^2+2.*mu*xi^2);
    n=floor( (angle(gamma)-T/2*abs(gamma) ...
        .*sin(angle(gamma))+pi)/(2*pi) );
    % calculate coefficients for transform
    A=log( abs(2.*gamma.*exp(-gamma.*T/2)) ) ...
        + 1i.*(angle(2.*gamma.*exp(-gamma.*T/2))+2*pi*n) ...
        -log(gamma+kappa+(gamma-kappa).*exp(-gamma.*T));
    B=kappa^2*T/(xi^2)+(2*gamma.*exp(-gamma*T)...
        ./( gamma+kappa+(gamma-kappa).*exp(-gamma*T) ) -1)...
        .*V.*(gamma-kappa)./(xi^2);

    out= 2*kappa/(xi^2).*A + B;

end
