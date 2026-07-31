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



function Delta = CalcDelta(LD, method)
%Calculates the Delta of B
%Specify method='for','adj','ads','FD' for forward, adjoint, adjoint
%summation, finite differences
    
    tstart = LD.StartMessage('Calculating Delta ');
    LD.SendMessage('using method ');
    LD.SendMessage(method);
    LD.SendMessage('... ');    
    
    if(strcmp(method,'FD'))
        Delta = FD_Delta(LD);
    else
        Delta = zeros(1,LD.m);
        %Calculate Delta in all paths
        for omega = 1:LD.paths
            D = BuildFactorMatricesD(LD, omega);
            V = BuildStartVectorsV(LD, omega);            
            Delta = Delta + DeltaPath(LD,D,V,method,omega);
        end

        %calculate average
        Delta = Delta / LD.paths;
    end
    
    LD.EndMessage(tstart);
            
end


