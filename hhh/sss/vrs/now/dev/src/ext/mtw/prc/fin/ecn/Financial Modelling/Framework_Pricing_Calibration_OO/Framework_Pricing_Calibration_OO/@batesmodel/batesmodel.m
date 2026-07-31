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



classdef batesmodel < model
    properties %(SetAccess = 'public', GetAccess = 'public')
        pnparams = [];
        pparams = [];       % this is a struct
        pmarket = '';
        parvec = [];
        usevec = [];
    end
    
    properties (Constant = true)    % constants
        pname = 'Bates';
    end
    
    methods 
        function m = batesmodel(params)
            m.pnparams = 8;
            
            m.parvec = ones(1,m.pnparams);
            m.usevec = ones(1,m.pnparams);
            
            m.pparams.v0 = params.v0;          % the initial variance
            m.pparams.theta = params.theta;    % the long term variance
            m.pparams.kappa = params.kappa;    % the mean reversion  
            m.pparams.omega = params.omega;          % the volatility of variance
            m.pparams.rho = params.rho;        % the correlation to underlying
            
            m.pparams.lambda = params.lambda;  % intensity
            m.pparams.muj = params.muj;        % mean jump height
            m.pparams.sigmaj = params.sigmaj;   % jump volatility
           
            m.parvec(1) = m.pparams.v0;
            m.parvec(2) = m.pparams.theta;
            m.parvec(3) = m.pparams.kappa;
            m.parvec(4) = m.pparams.omega;
            m.parvec(5) = m.pparams.rho;
            m.parvec(6) = m.pparams.lambda;
            m.parvec(7) = m.pparams.muj;
            m.parvec(8) = m.pparams.sigmaj;
            
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
            
            if isfield(params,'uselambda')
                m.usevec(6) = params.uselambda;
            end
            if isfield(params,'usemuj')
                m.usevec(7) = params.usemuj;
            end
            
            if isfield(params,'usesigmaj')
                m.usevec(8) = params.usesigmaj;
            end
        end
    end
    methods
        function [y1 y2 y3] = initcumulants(m,T,t_star,r,d,params)
        % compute cumulants
            vInst = params(1); vLong = params(2); kappa = params(3);
            omega = params(4); rho = params(5); lambda = params(6);
            muj = params(7); sigmaj = params(8);
            y1 = (r-d).*T + 0.5*((1-exp(-kappa*T))*(vLong-vInst)/kappa - vLong*T) + lambda*muj*T;
            y2 = 1/8/kappa^2*(omega*T.*exp(-kappa*T)*(vInst-vLong)*(8*kappa*rho-4*omega)...
                    +8*rho*omega*(1-exp(-kappa*T))*(2*vLong-vInst)...
                    +2*vLong*T*(-4*kappa*rho*omega + omega^2 + 4*kappa^2)...
                    +omega^2/kappa*((vLong-2*vInst)*exp(-2*kappa*T)...
                    +vLong*(6*exp(-kappa*T)-7)+2*vInst)...
                    +8*kappa*(vInst-vLong)*(1-exp(-kappa*T))) + lambda*(sigmaj^2+muj^2)*T;
            y3 = 0.0 + lambda * (3*sigmaj^2*(sigmaj^2+2*muj^2)+muj^4).*T;
        end
        
        function phi = cf1(m, u,T,t_star,r,d, params,paramsf,usevec)
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
                lambda = params(6); mu_j=params(7); sig_j = params(8);
    
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

                phi1 = A + repmat(1i*u,1,lenT)*diag((r-d).*(T-t_star));
                if t_star == 0
                    phi1 = exp(phi1 + B*vInst);
                else
                   %Hong(2004)
                    ekt = exp(-kappa*t_star);
                    ct = 2*ko2/(1-ekt);
                    denom = 1-B/ct;
                    phi1 = exp(phi1 + B*ekt./denom*vInst).*(denom.^(-2*ko2*vLong));
                end
            
                phi2 = exp(lambda*repmat(-mu_j*u*1i + (exp(u*1i*log(1.0+mu_j)+0.5*sig_j*sig_j*u*1i.*(u*1i-1.0))-1.0),1,lenT)*matT);
                phi = phi1 .* phi2;
            end
            
 
    end
    methods
        % visitor type but matlab does not allow call by ref!
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
end
