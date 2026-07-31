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



classdef LMMDer
    %A superclass for handling LMM Derivatives
    
    %The LMM Simulation assumes a tenor structure of the form 0 = T_1 < ... < T_{m+1}
    properties (GetAccess='public', SetAccess = 'public')   %Input Parameters
        m=10           %maturity
        tau = []       %vector of tenor distances, tau(i) = T_{i+1} - T_{i}, i = 1, ..., m
        L=[]           %LIBOR initial values
        sigma=[]       %volas for LIBORs (assumed to be constant for each LIBOR)
        paths=100      %number of paths in Monte Carlo Simulation
        epsilon=0.001  %finite difference
        msg=0          %display messages (0=no 1=yes)
        frozen=1       %if frozen, output properties Price, Delta, Gamma, Vega are not recalculated when accessed
        method='ads'   %standard method to calculate the greeks: 'for'=forward, 'adj'=adjoint, 'ads'=summation, 'FD'=finite differences
    end
    
    properties (GetAccess='public', SetAccess = 'public')     %Internal Data
        Z=[]           %Gaussian random vectors (declared public to make debugging easier)
    end
    
    properties (GetAccess='public', SetAccess = 'protected')     %Output
        LIBORs=[]      %LIBORs of LMM Simulation: LIBORs(i,n,omega) = i-th Libor (which 'dies' at T_i, i=1,...,m) in n-th time step in path omega
        Price=[]       %Price
        Delta=[]       %Delta
        Gamma=[]       %Gamma 
        Vega=[]        %Vega
    end                   

    %small methods declared here
    methods
        
        %constructor
        function LD = LMMDer()
        end
        
        %sends messages if msg <> 0
        function SendMessage(LD,message)
            if(LD.msg)
                fprintf(message);
            end
        end

        %sends Start message if msg <> 0
        function tstart = StartMessage(LD,message)
            if(LD.msg)
                fprintf(message);
            end
            tstart = tic;
        end        
        
        %sends Start message if msg <> 0
        function EndMessage(LD, tstart)
            if(LD.msg)
                tend = toc(tstart);
                fprintf('done. - %f sec \n', tend);
            end
        end    
        
    end
    
    %Setters und Getters
    methods
        
        function LD = set.tau(LD,value)
            if(max(size(value))==1)
                LD.tau = ones(LD.m,1) * value; 
            else
                LD.tau = value;
            end
        end

        function LD = set.L(LD,value)
            if(max(size(value))==1)
                LD.L = ones(LD.m,1) * value; 
            else
                LD.L = value;
            end
        end
        
        function LD = set.sigma(LD,value)
            if(max(size(value))==1)
                LD.sigma = ones(LD.m,1) * value; 
            else
                LD.sigma = value;
            end
        end
        
        
        function value = get.Price(LD)
            if(LD.frozen)
                value = LD.Price;
            else
                LD = LD.CalcPrice;
                value = LD.Price;
            end
        end
        
        function value = get.Delta(LD)
            if(LD.frozen)
                value = LD.Delta;
            else
                LD = LD.CalcPrice;
                value = LD.CalcDelta(LD.method);
            end
        end

        function value = get.Gamma(LD)
            if(LD.frozen)
                value = LD.Gamma;
            else
                LD = LD.CalcPrice;
                value = LD.CalcGamma(LD.method);
            end
        end

        function value = get.Vega(LD)
            if(LD.frozen)
                value = LD.Vega;
            else
                LD = LD.CalcPrice;
                value = LD.CalcVega(LD.method);
            end
        end

    end
    
    %Abstract (=virtual) Methods to be overloded in subclasses
    methods (Abstract =true, Access = 'protected')
        H = BuildMatrixH(LD, DMat, V, omega)
        V = BuildStartVectorsV(LD, omega)
        Delta = DeltaPath(LD, D, V, method, omega)
        w = GammaPath(LD, D, C, V, method, omega)
        Vega = VegaPath(LD, D, BMat, V, method, omega)
        LD = CalcPrice(LD)
    end

    %bigger methods declared externally
    methods
        LD = Initialize(LD)
        LD = MonteCarlo(LD)
        LD = LMM_Simulation(LD)
        
        D = BuildFactorMatricesD(LD,omega)
        C = BuildMatricesC(LD, Delta, E)
        E = BuildMatricesE(LD, D, omega)
        BMat = BuildTranslationMatricesB(LD, omega)
		[w A] = forward_method(LD, A1, B, C, v)
		w = adjoint_method(LD, A1, D, C, v)
		w = bermudan_method(LD, A1, D, C, V, r)
        
        Delta = CalcDelta(LD, method)
        Delta = FD_Delta(LD)
        Gamma = CalcGamma(LD, method)
        Gamma = FD_Gamma(LD)
        Vega = CalcVega(LD, method)
        Vega = FD_Vega(LD)
        propYData = DrawPlot(LD, K, propX, propY, range)
    end
    
end

