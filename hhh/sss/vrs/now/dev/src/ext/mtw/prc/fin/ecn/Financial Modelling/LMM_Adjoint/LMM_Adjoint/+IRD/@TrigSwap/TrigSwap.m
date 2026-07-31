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



classdef TrigSwap < IRD.LMMDer
    %Trigger Swaption
    
    properties  %Input Parameters
        e=5          %first observation date
        K=[]         %Trigger Levels
        s=0.2        %Spread Rate
        kappa=0.1;   %fixed rate
        N=10000;     %nominal value
    end
    
    properties (GetAccess='public', SetAccess = 'private')     %Internals
        Triggered;      %Time index at which Swap is triggered
    end            
    
    
    methods     %declared internally
        function TS = TrigSwap
            TS = TS@IRD.LMMDer;
        end
    end
    
    methods     %declared externally
        TS = Initialize(TS)
        TS = CalcTriggered(TS);
        TS = MCPayoff(TS);
    end
    
    %Setters and Getters
    methods
        function TS = set.K(TS,value)
            if(max(size(value))==1)
                TS.K = ones(TS.m,1)*value;
            else
                TS.K=value;
            end
        end
    end
    
    %Making abstract methods from superclass concrete
    methods (Access='protected')
        H = BuildMatrixH(TS, DMat, V, omega)
        V = BuildStartVectorsV(TS, omega)
        Delta = DeltaPath(TS, D, V, method, omega)
        w = GammaPath(TS, D, C, V, method, omega)
        Vega = VegaPath(TS, D, BMat, V, method, omega)
        TS = CalcPrice(TS)
    end
    
end

