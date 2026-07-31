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



classdef hestonmodel < model
    % Implementation of the Heston Stochastic Volatility model
    % dS(t) = (r-d) S(t) dt + sqrt(V(t)) S(t) dW_2(t)
    % dV(t) = kappa (theta - V(t)) dt + nu sqrt(V(t)) dW_2(t)
    % S(0) = s0
    % V(0) = v0
    %
    % kappa is the mean reversion
    % theta is the long term variance
    % nu is the volatility of variance
    % rho is the correlation between W_1 and W_2
    % v0 is the spot variance
    % S0 is the spot underlying
    
    properties %(SetAccess = 'public', GetAccess = 'public')
        pnparams = [];
        pparams = [];       % this is a struct
        pmarket = '';
        caltime = [];
        parvec = [];
        usevec = [];
    end
    
    properties (Constant = true)    % constants
        pname = 'Heston';
    end
    
    methods 
        function m = hestonmodel(params)
            m.pnparams = 5;
            
            m.parvec = ones(1,m.pnparams);
            m.usevec = ones(1,m.pnparams);
            
            m.pparams.v0 = params.v0;          % the initial variance
            m.pparams.theta = params.theta;    % the long term variance
            m.pparams.kappa = params.kappa;    % the mean reversion
            m.pparams.omega = params.omega;          % the volatility of variance
            m.pparams.rho = params.rho;        % the correlation to underlying
            
            m.parvec(1) = m.pparams.v0;
            m.parvec(2) = m.pparams.theta;
            m.parvec(3) = m.pparams.kappa;
            m.parvec(4) = m.pparams.omega;
            m.parvec(5) = m.pparams.rho;
            
            if isfield(params,'usev0')
                m.usevec(1) = params.usev0;
            end
            
            if isfield(params,'usetheta')
                m.usevec(2) = params.usetheta;
            end
            
            if isfield(params,'usekappa')
                m.usevec(3) = params.usekappa;
            end
            
            if isfield(params,'useomega')
                m.usevec(4) = params.useomega;
            end
            
            if isfield(params,'userho')
                m.usevec(5) = params.userho;
            end
            
             
        end
    end
    methods
        function [y1 y2 y3] = initcumulants(m,T,t_star,r,d,params)
        % compute cumulants
            vInst = params(1); vLong = params(2); kappa = params(3);
            omega = params(4); rho = params(5);
            y1 = (r-d).*T + 0.5*((1-exp(-kappa*T))*(vLong-vInst)/kappa - vLong*T);
            y2 = 1/8/kappa^2*(omega*T.*exp(-kappa*T)*(vInst-vLong)*(8*kappa*rho-4*omega)...
                    +8*rho*omega*(1-exp(-kappa*T))*(2*vLong-vInst)...
                    +2*vLong*T*(-4*kappa*rho*omega + omega^2 + 4*kappa^2)...
                    +omega^2/kappa*((vLong-2*vInst)*exp(-2*kappa*T)...
                    +vLong*(6*exp(-kappa*T)-7)+2*vInst)...
                    +8*kappa*(vInst-vLong)*(1-exp(-kappa*T)));
            %m.c4 = 0.0;
            y3 = zeros(length(T),1);
        end
        
        function phi = cf1(m,u,T,t_star,r,d, params,paramsf,usevec)
        % characteristic function for fixed and variable parameter sets

            pvec = zeros(1,length(usevec));
            pvec(usevec==true) = params;
            pvec(usevec==false) = paramsf;
            
            phi = m.cf(u,T,t_star,r,d, pvec);
            
        end    
    end
    
    methods (Static)
        function phi = cf(u,T,t_star,r,d, params)
            vInst = params(1); vLong = params(2); kappa = params(3);
            omega = params(4); rho = params(5);
                
            lenT = length(T);
            matT = diag(T-t_star);

            alfa = repmat((-1.0/2.0)*(u.*u+u*1i),1,lenT);
            beta = repmat(kappa - rho*omega*u*1i,1,lenT);
            omega2 = omega*omega;
            gamma = (1.0/2.0) * omega2;

            ko2 = kappa/omega2;
            
            D = sqrt(beta.*beta - 4.0*alfa*gamma);

            bD = beta-D;
            eDt = exp(-D * matT);

            G = bD ./ (beta+D);
            B = (bD ./ omega2) .*((1.0-eDt) ./ (1.0-G.*eDt));
            psi = (G .* eDt -1.0) ./ (G -1.0);
            A = (ko2 * vLong)*(bD*matT-2.0*log(psi));
            
            phi = A + repmat(1i*u,1,lenT)*diag((r-d).*(T-t_star));
            if t_star == 0
                phi = exp(phi + B*vInst);
            else
               %Hong(2004)
                ekt = exp(-kappa*t_star);
                ct = 2*ko2/(1-ekt);
                denom = 1-B/ct;
                phi = exp(phi + B*ekt./denom*vInst).*(denom.^(-2*ko2*vLong));
            end
                      
        end
    
    end
    
    methods
        % visitor type but matlab does not allow for call by ref!
        function v = accept(m, modelvisitor)
            v = modelvisitor.visit(m);
        end
    end
    
    methods
        % for illustration only
        function print(m)
            sprintf('I am a %s model',m.pname)
        end
    end
    
    methods (Static)
        function v = getval()
            v = 90;
        end
    end
    
   methods (Access = 'public')
        function currentN = getCurrentN(m)
            currentN = m.pnparams;
        end
        
    end
end
