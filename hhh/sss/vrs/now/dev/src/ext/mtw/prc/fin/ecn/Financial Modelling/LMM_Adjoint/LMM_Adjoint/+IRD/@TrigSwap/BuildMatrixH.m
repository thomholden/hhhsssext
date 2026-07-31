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



function H = BuildMatrixH(TS, DMat, V, omega)
%Builds all the Hessian matrices h^{\mu}(n) for path omega
%h(i,j,mu) contains entry (i,j) of h^{(\mu)}
%and then sums over all mu
%Vectorized Version

    %Calculate prefactors
    L = diag(TS.LIBORs(:,:,omega));
    alpha = zeros(TS.m,1);
    alpha = 1 + TS.tau .* L;
    alpha = cumprod(alpha);
    alpha = TS.N ./ alpha;
    alpha = alpha .* TS.tau;

    h = zeros(TS.m,TS.m,TS.m);
    r = TS.Triggered(omega);
    
    % e <= mu <= r-1
    x = TS.tau ./ (1 + TS.tau .* L);
    y = TS.tau ./(1 + TS.tau .* L);
    A = x * x.';    
    for mu = TS.e:r-1
        h(1:mu,1:mu,mu) = A(1:mu,1:mu);
        h(1:mu,1:mu,mu) = h(1:mu,1:mu,mu) + diag(diag(h(1:mu,1:mu,mu)));
    end
    
    % mu <= r <= m
    for mu = r:TS.m        
        %1 <= i,j <= mu -1
        x = TS.tau ./ (1 + TS.tau .* L);
        h(1:mu-1,1:mu-1,mu) = repmat(- alpha(mu) * x(1:mu-1),1,mu-1);
        %1 <= j <= mu -1, i = mu
        h(mu,1:mu-1,mu) = - x(1:mu-1) * alpha(mu) * (1 + TS.tau(mu) * TS.kappa) / ( (1 + TS.tau(mu) * TS.LIBORs(mu,mu,omega))^2 );
        %j = mu, 1 <= i <= mu-1
        h(1:mu-1,mu,mu) = - x(1:mu-1) * alpha(mu) * (1 - TS.tau(mu) *(TS.LIBORs(mu,mu,omega) - TS.kappa) / (1 + TS.tau(mu) * TS.LIBORs(mu,mu,omega)) ) ;
        %j=mu=i
        h(mu,mu,mu) = alpha(mu) * TS.tau(mu)^2 * (TS.LIBORs(mu,mu,omega) - TS.kappa) * (2 + TS.tau(mu) * TS.LIBORs(mu,mu,omega)) / ( (1 + TS.tau(mu) * TS.LIBORs(mu,mu,omega))^2 );
    end
    
    H = sum(h,3);    
end


% %Loop Version
% function H = BuildMatrixH(TS, DMat, V, omega)
% %Builds all the Hessian matrices h^{\mu}(n) for path omega
% %h(i,j,mu) contains entry (i,j) of h^{(\mu)}
% %and then sums over all mu
% 
%     %Calculate prefactors
%     alpha = zeros(TS.m,1);
%     for nu = 1:TS.m
%         alpha(nu) = 1 + TS.tau(nu) * TS.LIBORs(nu,nu,omega);
%     end
%     alpha = cumprod(alpha);
%     alpha = TS.N ./ alpha;
%     alpha = alpha .* TS.tau;
% 
%     h = zeros(TS.m,TS.m,TS.m);
% 
%     for mu = TS.e:TS.Triggered(omega)-1
%         for j=1:mu
%             for i=1:mu
%                 h(i,j,mu) = TS.tau(i) * TS.tau(j) /(1 + TS.tau(j) * TS.LIBORs(j,j,omega)) / (1 + TS.tau(i) * TS.LIBORs(i,i,omega));
%                 if(i==j)
%                     h(i,j,mu) = h(i,j,mu) * 2;
%                 end
%             end
%         end
%     end
%     for mu = TS.Triggered(omega):TS.m
%         for j = 1 : mu-1
%             for i = 1 : mu-1
%                 h(i,j,mu) = - alpha(mu) * TS.tau(i) / (1 + TS.tau(i) * TS.LIBORs(i,i,omega));
%             end
%             %case i = mu
%             h(mu,j,mu) = - alpha(mu) * TS.tau(j) * (1 + TS.tau(mu) * TS.kappa) / (1 + TS.tau(j) * TS.LIBORs(j,j,omega)) / ( (1 + TS.tau(mu) * TS.LIBORs(mu,mu,omega))^2 );
%         end
%         %case j = mu
%         for i=1:mu-1
%             h(i,mu,mu) = - alpha(mu) * (1 - TS.tau(mu) *(TS.LIBORs(mu,mu,omega) - TS.kappa) / (1 + TS.tau(mu) * TS.LIBORs(mu,mu,omega)) ) * TS.tau(mu) / (1 + TS.tau(i) * TS.LIBORs(i,i,omega));
%         end
%         %case j=mu=i
%         h(mu,mu,mu) = alpha(mu) * TS.tau(mu)^2 * (TS.LIBORs(mu,mu,omega) - TS.kappa) * (2 + TS.tau(mu) * TS.LIBORs(mu,mu,omega)) / ( (1 + TS.tau(mu) * TS.LIBORs(mu,mu,omega))^2 );
%     end
%     
%     H = sum(h,3);
% end
% 
% function x = Compare(H,I,m)
%     x = 0;
%     for i=1:m
%         for j=1:m
%                 x = x + (H(i,j)-I(i,j))^2;
%         end
%     end
%     x = sqrt(x);
% end
% 