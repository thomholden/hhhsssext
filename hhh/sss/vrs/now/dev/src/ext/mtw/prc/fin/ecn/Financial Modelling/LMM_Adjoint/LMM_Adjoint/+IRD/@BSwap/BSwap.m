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



classdef BSwap < IRD.LMMDer
    %Bermudan Swaption
    %   Analyzes price and greeks of a Bermudan Interest Rate Swaption
    
    properties      %Input Parameters
        e=5           %first exercise time index, 1 <= e <= m
        K=0.3         %strike rate
        phi=1         %payer (=+1) or receiver (=-1) swaption?
        nom=10000     %nominal value
        d=3           %number of regression parameters
    end
    
    properties (GetAccess='private', SetAccess = 'private')     %Internals
        optimal=[]     %optimal exercise indices
        SwapRates=[]   %SwapRates(n,omega) returns n-th SwapRate in path omega
        Payoff=[]      %Payoff(n,omega) returns payoff at time index n in path omega
    end    
    
    %small methods declared here
    methods
        
        %constructor
        function B = BSwap()
            B = B@IRD.LMMDer;
        end
        
        function value = DynGet(B,prop)
            value = B.(prop);
        end
        
        function B = DynSet(B,prop,value)
            B.(prop)=value;
        end
        
        
    end
    
    %bigger methods declared externally
    methods
        B = Initialize(B)
        B = LSM_Simulation(B)
        B = CalcSwapRatesPayoff(B)
    end
    
    %Making abstract methods from superclass concrete
    methods (Access='protected')
        H = BuildMatrixH(B, DMat, V, omega)
        V = BuildStartVectorsV(B, omega)
        Delta = DeltaPath(LD, D, V, method, omega)
        w = GammaPath(LD, D, C, V, method, omega)
        Vega = VegaPath(LD, D, BMat, V, method, omega)
        B = CalcPrice(B)
    end
    
end

