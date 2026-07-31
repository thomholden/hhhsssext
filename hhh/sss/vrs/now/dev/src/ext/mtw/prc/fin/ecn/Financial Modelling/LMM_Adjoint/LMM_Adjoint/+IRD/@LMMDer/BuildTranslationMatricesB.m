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



function BMat = BuildTranslationMatricesB(LD, omega)
%Builds all the factor matrices B(n) at time index n for path omega
%B(i,j,n) contains entry (i,j) of B(n)
%Vectorized Version

    BMat = zeros(LD.m,LD.m,LD.m-1);
    
    for n = 1:LD.m-1        
        %n+1 <= i <= m, n+1 <= j <= i-1
        x = LD.LIBORs(:,n+1,omega) .* LD.sigma;
        y = LD.tau .* LD.LIBORs(:,n,omega) ./ (1 + LD.tau .* LD.LIBORs(:,n,omega));
        A = x * y.';
        A = tril(A(n+1:LD.m,n+1:LD.m),-1);
        BMat(n+1:LD.m,n+1:LD.m,n) = A;
        %n+1 <= i <= m, j=i
        mu = LD.tau .* LD.LIBORs(:,n,omega) .* LD.sigma ./ (1 + LD.tau .* LD.LIBORs(:,n,omega));
        mu(1:n) = 0;
        mu = LD.sigma .* cumsum(mu);
        x = LD.LIBORs(:,n+1,omega) .*( mu + LD.sigma .* LD.tau .* LD.LIBORs(:,n,omega) ./ (1 + LD.tau .* LD.LIBORs(:,n,omega)) );
        x(1:n) = 0;
        BMat(:,:,n) = BMat(:,:,n) + diag(x);
    end
        
end

% % Loop Version
% function BMat = BuildTranslationMatricesB(LD, omega)
% %Builds all the factor matrices B(n) at time index n for path omega
% %B(i,j,n) contains entry (i,j) of B(n)
% 
%     BMat = zeros(LD.m,LD.m,LD.m-1);
%     
%     for n = 1:LD.m-1
%         for i=n+1:LD.m
%             for j=n+1:i-1
%                 BMat(i,j,n) = LD.LIBORs(i,n+1,omega) * LD.sigma(i) * LD.tau(j) * LD.LIBORs(j,n,omega) / (1 + LD.tau(j) * LD.LIBORs(j,n,omega));
%             end
%             %case j=i
%             for k=n+1:i
%                 BMat(i,i,n) = BMat(i,i,n) + LD.tau(k) * LD.LIBORs(k,n,omega) * LD.sigma(k) / (1 + LD.tau(k) * LD.LIBORs(k,n,omega));
%             end
%             BMat(i,i,n) = LD.sigma(i) * BMat(i,i,n) + LD.sigma(i) * LD.tau(i) * LD.LIBORs(i,n,omega) / (1 + LD.tau(i) * LD.LIBORs(i,n,omega));
%             BMat(i,i,n) = BMat(i,i,n) * LD.LIBORs(i,n+1,omega);
%         end
%     end
%     
% end
