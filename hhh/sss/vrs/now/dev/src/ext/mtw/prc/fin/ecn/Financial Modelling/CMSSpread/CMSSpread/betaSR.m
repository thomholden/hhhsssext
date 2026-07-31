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

function y = betaSR( t,fix, ausz,T,q,a,b,c,d , nu,eta,coeff1, coeff2)

J=fix:ausz-1;

qsigma = q(J).*sigma(T(J)-t,a,b,c,d);
sigmabeta = sigma(T(J)-t,a,b,c,d) ...
    .* beta(T(J)-t,T(length(T)-1),coeff1, coeff2);

rhomat = rho_new(T(J),T(J),t,nu,eta);

qsigmamat = repmat(qsigma',1,length(J));

y = sum(sum(qsigmamat .* rhomat).*sigmabeta) ...
    /((ausz-fix)*sigmaSRsquared(t,fix,ausz,T,q,a,b,c,d,nu,eta));

% this is the code programmed as a loop but slower!
% y=0;
% for i=fix:ausz-1
%    tmp = qsigma .* rho(T(i),T(J),t);
%    y=y+sigmabeta(i+1-fix).*sum(tmp);
% end
% 
% out=y/((ausz-fix)*sigmaSRQuadrat(t,fix,ausz,T,q,a,b,c,d));


end

