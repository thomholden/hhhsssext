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



function D = BuildFactorMatricesD(LD,omega)
%Builds all the factor matrices D(n) at time index n for path omega
%D(n) is the Jacobian of the evolution map F_n of the LMM
%D(i,k,n) contains entry (i,k) of D(n)
%Vectorized Version (unreadable and very fast)

    D = zeros(LD.m,LD.m,LD.m-1);       %Pre-allocate and initialize
    S = LD.sigma.^2;
    ST = LD.sigma .* LD.tau;
    for n = 1:LD.m-1
        %Filling the diagonal
        v = LD.LIBORs(:, n + 1, omega) ./ LD.LIBORs(:, n , omega) + S .* (LD.tau * LD.tau(n)) .* LD.LIBORs(:, n + 1, omega) ./ ((1 + LD.tau .* LD.LIBORs(:, n, omega)).^2);
        v(1:n) = 1;
        D(:,:,n) = diag(v);
        %Filling subdiagonal entries
        x = ST * LD.tau(n) ./ ( (1 + LD.tau .* LD.LIBORs(:, n, omega)).^2);
        y = LD.LIBORs(:, n + 1, omega) .* LD.sigma;
        A = y*x.';
        seg=n+1:LD.m;
        D(seg,seg,n) = D(seg,seg,n) + tril(A(seg,seg),-1);
    end
            
end



% function D = BuildFactorMatricesD(LD,omega)
% %Builds all the factor matrices D(n) at time index n for path omega
% %D(n) is the Jacobian of the evolution map F_n of the LMM
% %D(i,k,n) contains entry (i,k) of D(n)
% %Non Vectorized Version used before: is correct but slow
% 
%     D = zeros(LD.m,LD.m,LD.m-1);
%     for n = 1:LD.m-1
%         %case i = k <= n;
%         for k = 1:n
%             D(k,k,n) = 1;
%         end
%         for k = n+1 : LD.m
%             %case i = k >= n+1;
%             D(k,k,n) = LD.LIBORs(k, n + 1, omega) / LD.LIBORs(k, n , omega) + LD.sigma(k)^2 * LD.tau(k) * LD.tau(n) * LD.LIBORs(k, n + 1, omega) / ((1 + LD.tau(k) * LD.LIBORs(k, n, omega))^2);
%             %case i > k >= n+1;
%             for i = k+1:LD.m
%                 D(i,k,n)= LD.LIBORs(i, n + 1, omega) * LD.sigma(i) * LD.sigma(k) * LD.tau(k) * LD.tau(n) / ( (1 + LD.tau(k) * LD.LIBORs(k, n, omega))^2);
%             end
%         end
%     end
%     
% end
