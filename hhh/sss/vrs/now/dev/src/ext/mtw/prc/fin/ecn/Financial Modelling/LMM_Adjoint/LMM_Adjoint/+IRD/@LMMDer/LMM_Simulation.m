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



function LD = LMM_Simulation(LD)
    
    tstart = LD.StartMessage('Calculating LIBORs Vectorized...');
    
    LD.LIBORs = zeros(LD.m, LD.m, LD.paths);
    S = zeros(LD.m,1);
    
    for omega = 1:LD.paths
        LD.LIBORs(:,1,omega) = LD.L;
    end

    
    for omega=1:LD.paths
        for n = 1:LD.m-1
            S = LD.sigma .* LD.tau .* LD.LIBORs(:,n,omega) ./ ( 1 + LD.tau .* LD.LIBORs(:,n,omega) );
            S(1:n) = 0;
            S = cumsum(S);
            S = exp( LD.sigma .*( (S - LD.sigma*0.5)* LD.tau(n) + LD.Z(n,omega) *sqrt(LD.tau(n)) ) );
            LD.LIBORs(n+1:LD.m,n+1,omega) = LD.LIBORs(n+1:LD.m,n,omega) .* S(n+1:LD.m);
        end
    end
    
    LD.EndMessage(tstart);
    
end
