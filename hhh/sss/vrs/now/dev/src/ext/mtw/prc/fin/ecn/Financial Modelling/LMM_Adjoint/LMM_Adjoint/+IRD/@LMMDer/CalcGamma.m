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



function Gamma = CalcGamma(LD, method)
%Calculates the Gamma

    tstart = LD.StartMessage('Calculating Gamma using method ');
    LD.SendMessage(method);
    LD.SendMessage('... ');
    
    if(strcmp(method,'FD'))
        Gamma = FD_Gamma(LD);
    else
        Gamma = zeros(LD.m,LD.m);
        %calculate Gamma in all paths
        for omega = 1:LD.paths
            V = LD.BuildStartVectorsV(omega);
            v = sum(V);
            D = LD.BuildFactorMatricesD(omega);
            E = LD.BuildMatricesE(D, omega);
            [w Delta ] = LD.forward_method(eye(LD.m), D, [], v);
            C = LD.BuildMatricesC(Delta, E);
            H = LD.BuildMatrixH(Delta, V, omega);

            Y = zeros(LD.m,LD.m);
            Y = Delta(:,:,LD.m).' * H * Delta(:,:,LD.m);  %calculate Y
            Gamma = Gamma + Y;

            w = GammaPath(LD,D,C,V,method,omega);
            
            Gamma = Gamma + w;  %finally obtain Gamma in current path omega
        end

         %calculate average
        Gamma = Gamma / LD.paths;
        
    end
    
    LD.EndMessage(tstart);
end


