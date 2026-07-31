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



function V = BuildStartVectorsV(B, omega)
%Builds all the necessary start vectors V(r),...,V(m) in current path omega
%V(n,j) contains j-th entry of n-th start vector
%Vectorized Version
    %Initialize
    r = B.optimal(omega);
    V = zeros(B.m,B.m);    
    if(r)
        %Calculate discount factors
        L = diag(B.LIBORs(:,:,omega));
        disc = 1 + B.tau .* L;
        disc = 1 ./ cumprod(disc);
        %Calculate Prefactors
        prefact = B.phi * B.nom * B.tau .* disc;
        %Build diagonal entries
        x = prefact .* ( 1 - ( B.tau .* (L - B.K) ) ./ ( 1 + B.tau .* L ));
        V(r:B.m,r:B.m) = diag(x(r:B.m));
        %Build subdiagonal entries
        a = prefact .* (B.K - L);
        b = B.tau ./ (1 + B.tau .* L);
        Z = tril(a * b.',-1);
        V(r:B.m,1:B.m) = V(r:B.m,1:B.m) + Z(r:B.m,1:B.m);
    end    
end

% %Original Loop Version: correct, but slow
% function V = BuildStartVectorsVLoop(B, omega)
% %Builds all the necessary start vectors V(r),...,V(m) in current path omega
% %V(n,j) contains j-th entry of n-th start vector
% 
%     Initialize
%     r = B.optimal(omega);
%     V = zeros(B.m,B.m);
%     
%     if(r)
%         Calculate auxilliary product
%         prod = 1;
%         for nu = 1:r-1
%             prod = prod * (1 + B.tau(nu) * B.LIBORs(nu,nu,omega));
%         end
%         prod = 1 / prod;
% 
%         Builds all start vectors
%         for n = r : B.m
%             prod = prod / (1 + B.tau(n) * B.LIBORs(n, n, omega));        
%             prefact = B.phi * B.nom * B.tau(n);
% 
%             for j = 1:n-1
%                 V(n,j) = prefact * prod * B.tau(j) * (B.K - B.LIBORs(n, n,omega))  / (1 + B.tau(j) * B.LIBORs(j, j,omega));
%             end
%             V(n,n) = prefact * prod * ( 1 - ( B.tau(n) * (B.LIBORs(n, n,omega) - B.K) ) / ( 1 + B.tau(n) * B.LIBORs(n, n,omega) )  );
%         end
%     end
%     
% end
