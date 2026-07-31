% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Nikolai Nowaczyk
%   	    Joerg Kienitz
%           Daniel Wetterau
%           
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Nikolai Nowaczyk, Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function H = BuildMatrixH(B, DMat, V, omega)
%Builds all the Hessian matrices h^{\mu}(n) for path omega
%h(i,j,mu) contains entry (i,j) of h^{(\mu)}
%and then sums over all mu
%Vectorized Version

    r = B.optimal(omega);
    h = zeros(B.m,B.m,B.m);

    if(r)
        for mu = r:B.m
            %Calculate prefactors \alpha_{\mu}
            L = diag(B.LIBORs(:,:,omega));
            alpha = 1 + B.tau .* L;
            alpha = B.phi * B.nom * B.tau ./ cumprod(alpha); 
            %Go through various cases
            %1 <= i,j <= mu-1
            x = alpha(mu) * (- B.tau ./ (1 + B.tau .* L));
            h(1:mu-1,1:mu-1,mu) = repmat(x(1:mu-1),1,mu-1);
            %1 <= j <= mu-1, i=mu
            x = -alpha(mu) * (1 + B.tau(mu) * B.K) / ( (1 + B.tau(mu) * L(mu))^2 )  *   B.tau ./ (1 + B.tau .* L);
            h(mu,1:mu-1,mu) = x(1:mu-1);
            %j=mu, 1 <= i <= mu-1
            x = alpha(mu) * ( 1 - B.tau(mu) * ( L(mu) - B.K ) / (1 + B.tau(mu) * L(mu)) ) * ( -B.tau ./ (1 + B.tau .* L));
            h(1:mu-1,mu,mu) = x(1:mu-1);
            %i=j=mu
            h(mu,mu,mu) = alpha(mu) *  B.tau(mu)^2 * (B.LIBORs(mu,mu,omega) - B.K) * ( 2 + B.tau(mu) * B.LIBORs(mu,mu,omega) ) / ( (1 + B.tau(mu) * B.LIBORs(mu,mu,omega))^2);
        end
    end
    
    H = sum(h,3);
    
end



% Loop Version
function H = BuildMatrixHLoop(B, DMat, V, omega)
%Builds all the Hessian matrices h^{\mu}(n) for path omega
%h(i,j,mu) contains entry (i,j) of h^{(\mu)}
%and then sums over all mu

    r = B.optimal(omega);
    h = zeros(B.m,B.m,B.m);

    if(r)
        for mu = r:B.m
            %Calculate prefector \alpha_{\mu}
            alphamu = B.phi * B.nom * B.tau(mu);
            for k = 1:mu
                alphamu = alphamu / (1 + B.tau(k) * B.LIBORs(k,k,omega));
            end
            %go through various cases of h^{(\mu)}
            for j = 1:mu-1
                for i = 1:mu-1
                    h(i,j,mu) = alphamu * (-B.tau(i) / (1 + B.tau(i)*B.LIBORs(i,i,omega)));
                end
                i = mu;
                h(i,j,mu) = alphamu * (-B.tau(j) * (1 + B.tau(mu) * B.K)) / ( (1 + B.tau(j) * B.LIBORs(j,j,omega)) * (1 + B.tau(mu) * B.LIBORs(mu,mu,omega))^2 );
            end
            j=mu;
            for i = 1:mu -1
                h(i,j,mu) = alphamu * ( 1 - B.tau(mu) * ( B.LIBORs(mu,mu,omega) - B.K ) / (1 + B.tau(mu) * B.LIBORs(mu,mu,omega)) ) * ( -B.tau(i) / (1 + B.tau(i) * B.LIBORs(i,i,omega)));
            end
            i=mu; %case i=j=mu
            h(i,j,mu) = alphamu *  B.tau(mu)^2 * (B.LIBORs(mu,mu,omega) - B.K) * ( 2 + B.tau(mu) * B.LIBORs(mu,mu,omega) ) / ( (1 + B.tau(mu) * B.LIBORs(mu,mu,omega))^2);
        end
    end
    
    H = sum(h,3);
end
