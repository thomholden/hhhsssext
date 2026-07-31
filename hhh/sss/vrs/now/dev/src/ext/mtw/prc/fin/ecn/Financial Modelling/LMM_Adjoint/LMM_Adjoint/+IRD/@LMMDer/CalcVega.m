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



function Vega = CalcVega(LD, method)

    tstart = LD.StartMessage('Calculating Vega ');
    LD.SendMessage('using method ');
    LD.SendMessage(method);
    LD.SendMessage('... ');
    
    if(strcmp(method,'FD'))
        Vega = FD_Vega(LD);
    else
        Vega = zeros(1,LD.m);
        %Calculate Vega in all paths
        for omega = 1:LD.paths
            D = BuildFactorMatricesD(LD, omega);
            BMat = BuildTranslationMatricesB(LD, omega);
            V = BuildStartVectorsV(LD, omega);
            Vega = Vega + VegaPath(LD, D, BMat, V, method, omega);
        end
    
        %calculate average
        Vega = Vega / LD.paths;
    end
    LD.EndMessage(tstart);
            
end

