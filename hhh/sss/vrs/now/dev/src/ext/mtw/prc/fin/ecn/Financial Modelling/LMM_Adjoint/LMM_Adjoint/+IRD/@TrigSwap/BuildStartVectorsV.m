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



function V = BuildStartVectorsV(TS, omega)
%Builds all the necessary start vectors V(e),...,V(m) in current path omega
%V(mu,j) contains j-th entry of n-th start vector
%Vectorized Version

    %Initialize
    V = zeros(TS.m,TS.m);
    
    %Calculate prefactors
    L = diag(TS.LIBORs(:,:,omega));
    alpha =1 + TS.tau  .* L;
    alpha = cumprod(alpha);
    alpha = TS.N ./ alpha;
    alpha = alpha .* TS.tau;
    
    r = TS.Triggered(omega);
    %Builds all start vectors
    %e <= mu <= r-1, 1<=j<=mu
    x = TS.tau ./ (1 + TS.tau .* L);
    A =- alpha * x.';
    B = tril(A);
    V(TS.e:r-1,1:TS.e-1) = A(TS.e:r-1,1:TS.e-1);
    V(TS.e:r-1,TS.e:r-1) = B(TS.e:r-1,TS.e:r-1);

    %r <= mu <= m, 1 <= j <= mu-1
    L = diag(TS.LIBORs(:,:,omega));
    x = alpha .* (TS.kappa - L);
    y = TS.tau ./ (1 + TS.tau .* L);
    A = x * y.';
    V(r:TS.m,1:r-1) = A(r:TS.m,1:r-1);
    V(r:TS.m,r:TS.m) = tril(A(r:TS.m,r:TS.m),-1);    
    
    %r <= mu <= m, j=mu
    x = alpha .* ( 1 - TS.tau .* (L - TS.kappa) ./ (1 + TS.tau .* L) );
    V(r:TS.m,r:TS.m) = V(r:TS.m,r:TS.m) + diag(x(r:TS.m));    
end

% %Loop Version
% function V = BuildStartVectorsV(TS, omega)
% %Builds all the necessary start vectors V(e),...,V(m) in current path omega
% %V(mu,j) contains j-th entry of n-th start vector
% 
%     %Initialize
%     V = zeros(TS.m,TS.m);
%     
%     %Calculate prefactors
%     alpha = ones(TS.m,1);
%     for nu = 1:TS.m
%         alpha(nu) =1 + TS.tau(nu) * TS.LIBORs(nu,nu,omega);
%     end
%     alpha = cumprod(alpha);
%     alpha = TS.N ./ alpha;
%     alpha = alpha .* TS.tau;
%     
%     %Builds all start vectors
%     for mu = TS.e : TS.Triggered(omega) - 1
%         for j=1:mu
%             V(mu,j) = - alpha(mu) * TS.tau(j) / (1 + TS.tau(j) * TS.LIBORs(j,j,omega));
%         end
%     end
%     for mu = TS.Triggered(omega) : TS.m
%         for j=1:mu-1
%             V(mu,j) = alpha(mu) * TS.tau(j) * (TS.kappa - TS.LIBORs(mu,mu,omega)) / (1 + TS.tau(j) * TS.LIBORs(j,j,omega)) ;
%         end
%         V(mu,mu) = alpha(mu) * ( 1 - TS.tau(mu) * (TS.LIBORs(mu,mu,omega) - TS.kappa) / (1 + TS.tau(mu) * TS.LIBORs(mu,mu,omega)) );
%     end
%     
% end
% 
% function x=Compare(V,W,m)
%     x=0;    
%     for i=1:m
%         for j=1:m
%             x = x + (V(i,j) - W(i,j))^2;
%         end
%     end
%     x = sqrt(x);
% end