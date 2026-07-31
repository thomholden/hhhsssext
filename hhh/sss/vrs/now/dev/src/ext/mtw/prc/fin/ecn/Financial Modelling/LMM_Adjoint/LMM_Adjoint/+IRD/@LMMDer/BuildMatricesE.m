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



function E = BuildMatricesE(LD, D, omega)
%Builds all the factor matrices E(n) at time index n for path omega
%E(:,:,i,n) is the Hessian of the i-th component F^i of the evolution map F
%of the LMM
%E(j,k,i,n) contains entry (j,k) of E^{(i)}(n)
%assumes that the input D is generated as in BuildFactorMatricesD
% Vectorized Version

    E = zeros(LD.m,LD.m,LD.m,LD.m-1);
    
    for n = 1:LD.m-1
        w = LD.sigma .* LD.tau * LD.tau(n) ./ ( (1 + LD.tau .* LD.LIBORs(:,n,omega)).^2 );
        u = w .* LD.tau ./ (1 + LD.tau .* LD.LIBORs(:,n,omega));
        z = 1 ./ LD.LIBORs(:,n,omega) + LD.sigma .* w;
        v = LD.LIBORs(:,n,omega) .* ( 1 ./ (LD.LIBORs(:,n,omega).^2) + LD.sigma.^2 .* w ./ (1 + LD.tau .* LD.LIBORs(:,n,omega) ) );
        b = LD.LIBORs(:,n+1,omega) .* LD.sigma;
        Y = D(:,:,n) .* repmat(LD.sigma,1,LD.m);
        for j = 1:LD.m
            %i=k>=n+1, i~=j
            x=D(:,j,n) .* z;
            E(n+1:LD.m,n+1:LD.m,j,n) = diag(x(n+1:LD.m));
            %i=k>=n+1, i=j
            if(j>=n+1)
                E(j,j,j,n) = E(j,j,j,n) - v(j);
            end                
            %i>k>=n+1, j~=k
            y = Y(:,j);
            A = w * y.';
            E(n+1:LD.m,n+1:LD.m,j,n) = E(n+1:LD.m,n+1:LD.m,j,n) + triu(A(n+1:LD.m,n+1:LD.m),1);
            %i>k>=n+1, j~=k
            if(j>=n+1)
                x = b * u(j);
                for i=j+1:LD.m
                    x(i) = E(j,i,j,n) - x(i);
                end
                E(j,j+1:LD.m,j,n) = x(j+1:LD.m);
            end
            
        end
    end    
    E = ipermute(E, [2 3 1 4]);
    
%     F = BuildMatricesELoop(LD, D, omega);
%     x = Compare(E,F,LD.m)
    
end

% Loop Version
function E = BuildMatricesELoop(LD, D, omega)
%Builds all the factor matrices E(n) at time index n for path omega
%E(:,:,i,n) is the Hessian of the i-th component F^i of the evolution map F
%of the LMM
%E(j,k,i,n) contains entry (j,k) of E^{(i)}(n)
%assumes that the input D is generated as in BuildFactorMatricesD

    E = zeros(LD.m,LD.m,LD.m,LD.m);
    
    for n = 1:LD.m-1
        for j = 1:LD.m
            for k = n+1:LD.m
                i=k;
                E(j,k,i,n) = D(i,j,n) * ( 1/LD.LIBORs(i,n,omega) + LD.sigma(i)^2 * LD.tau(i) * LD.tau(n) / ( (1 + LD.tau(i) * LD.LIBORs(i,n,omega))^2 ) );
                if(i==j)
                    E(j,k,i,n) = E(j,k,i,n) - LD.LIBORs(i,n,omega) * ( 1/(LD.LIBORs(i,n,omega)^2) + LD.sigma(i)^3*LD.tau(i)*LD.tau(n) / ( (1 + LD.tau(i) * LD.LIBORs(i,n,omega))^3 ) );
                end
                for i = k+1:LD.m
                    E(j,k,i,n) = D(i,j,n) * LD.sigma(i) * LD.sigma(k) * LD.tau(k) * LD.tau(n) / ( (1 + LD.tau(k) * LD.LIBORs(k,n,omega))^2 );
                    if(j==k)
                        E(j,k,i,n) = E(j,k,i,n) - LD.LIBORs(i,n+1,omega) * LD.sigma(i)*LD.sigma(k) * LD.tau(k)^2 * LD.tau(n) / ( (1 + LD.tau(k) * LD.LIBORs(k,n,omega))^3 );
                    end
                end
            end
        end
    end
end


function x = Compare(A, B, m)
    x = 0;
    for i=1:m
        for j=1:m
            for k=1:m
                for l=1:m-1
                    x = x + (A(i,j,k,l) - B(i,j,k,l))^2;
                end
            end
        end
    end
    x = sqrt(x);
end
             
