% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



classdef fftlewis 
    % classtype: derived class
    %
    % Description: This class uses the characteristic function to
    %              compute the prices of calls, puts or both simultanuously
    %
    % ref1 : Carr, Madan "..."
    % ref2 : Andrey Itkin, "Pricing options with VG model using FFT" 
    
    properties
        N = [];
        eta = [];
        lambda = [];
        b = [];
        ku = [];
        jvec = [];
        vj = [];
        % The member functions (additionally to base class)
        charfunc = [];      % characteristic function (model we consider)
        valfunc1 = [];      % valfunction for calls or puts
    end
    
    methods (Access = 'public')
        % Constructor
        function ocm = fftlewis(N_,eta_,model)
            ocm.N = 2^N_;                               % from base  
            ocm.eta = eta_;             
            ocm.charfunc = @(u,T,t_star,r,d,p) ...
                model.cf1(u,T,t_star,r,d,p,model.parvec(model.usevec==false),model.usevec);
            ocm.lambda = (2 * pi) / (ocm.N * ocm.eta);  % spacing for log strike output (23)
            ocm.b = (ocm.N * ocm.lambda) / 2;           % eqn (20) from ref1
            uvec = (1:ocm.N)';
            ocm.ku = - ocm.b + ocm.lambda * (uvec - 1); % eqn (19) from ref1
            ocm.jvec = (1:ocm.N)';
            ocm.vj = (ocm.jvec-1) * ocm.eta;
           
            % see ref2
            ocm.valfunc1 = ...
                @(T, t, r, d, params) ...
                    feval(ocm.charfunc,- ocm.vj - 0.5* 1i, T,t,r,d, params)./ ...
                        repmat(ocm.vj.^2 + 0.25,1,length(T));
                 
        end
        
        function y = price(ocm, T, t, S0, d, df, params,dataK,cp)
            
            lenK = length(dataK);
            lenT = length(T);
            
            %continuously compunded riskfree rate
            r = -log(df)./T;
            % computes a range of option prices (calls / puts); cp = 1
            % (Call), cp = 0 (Put)
            ret = ocm.valfunc1(T,t,r,d,params);
            tmp = (ret.*exp(1i * repmat(ocm.vj,1,lenT)* ocm.b))*ocm.eta;
            
            tmp(isnan(tmp)) = max(max(tmp));
            
            tmp = (tmp / 3) .* repmat((3 + (-1).^ocm.jvec - ((ocm.jvec - 1) == 0) ),1,lenT); 
    
            %valuation points of interest
            kappa = -log(dataK);
            %integral values at points of interest
            integralval = interp1(ocm.ku,real(repmat(exp(-0.5*ocm.ku),1,lenT).*fft(tmp))/pi,kappa);
            
            %call price matrix
            cpmat = S0*exp(-d*t)*(repmat(exp(-d*(T-t)),lenK,1) - repmat(exp(-r.*(T-t)),lenK,1).* integralval);

            indexset = repmat(cp',1,lenT);
            y = cpmat;
            y1 = y + exp(-d*t)*(repmat(exp(-r.*(T-t)),lenK,1).*repmat(S0*dataK,1,lenT)...
                - repmat(S0*exp(-d*(T-t)),lenK,1)); 

            y(indexset == 0) = y1(indexset == 0);           
        end
        
    end
    methods (Access = 'public')
        function currentN = getCurrentN(OBJ)
            currentN = OBJ.N;
        end
        
        function currentfunc = getCurrentFunc(OBJ)
            currentfunc = OBJ.charfunc;
        end
        function currentVj = getCurrentVj(OBJ)
            currentVj = OBJ.vj;
        end
        
        function currentEta = getCurrentEta(OBJ)
            currentEta = OBJ.eta;
        end
        
        function currentjvec = getCurrentJvec(OBJ)
            currentjvec = OBJ.jvec;
        end
        
        function currentku = getCurrentKu(OBJ)
            currentku = OBJ.ku;
        end
        
        function currentB = getCurrentB(OBJ)
            currentB = OBJ.b;
        end
    end
end
