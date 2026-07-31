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



classdef nigcirmodel < model
    
    properties
        pnparams = [];
        pparams = [];
        pmarket = '';
        parvec = [];
        usevec = [];
    end
    
    properties (Constant = true)
        pname = 'Normal Inverse Gaussian - CIR';
    end
    
    methods
        function m = nigcirmodel(params)
            m.pnparams = 6;
            
            m.parvec = ones(1,m.pnparams);
            m.usevec = ones(1,m.pnparams);
            
            m.pparams.alpha = params.alpha;
            m.pparams.beta = params.beta;
            m.pparams.delta = params.delta;
            m.pparams.kappa = params.kappa;
            m.pparams.eta = params.eta;
            m.pparams.lambda = params.lambda;

            m.parvec(1) = m.pparams.alpha;
            m.parvec(2) = m.pparams.beta;
            m.parvec(3) = m.pparams.delta;
            m.parvec(4) = m.pparams.kappa;
            m.parvec(5) = m.pparams.eta;
            m.parvec(6) = m.pparams.lambda;
            
            if isfield(params,'usealpha')
                m.usevec(1) = params.usealpha;
            end
            
            if isfield(params,'usebeta')
                m.usevec(2) = params.usebeta;
            end
            
            if isfield(params,'usedelta')
                m.usevec(3) = params.usedelta;
            end
            if isfield(params,'usekappa')
                m.usevec(4) = params.usekappa;
            end
            
            if isfield(params,'useeta')
                m.usevec(5) = params.useeta;
            end
            
            if isfield(params,'uselambda')
                m.usevec(6) = params.uselambda;
            end
        end
    end
    
    methods
       function [y1, y2, y3] = initcumulants(m,T,t_star,r,d,params)
            phi = @(u) log(m.cf(u,T,t_star,r,d,params));
            
            h1 = sqrt(eps(0.5)); h2 = sqrt(h1); h3 = sqrt(h2);
            df = @(u) 0.5*(phi(u+h1)-phi(u-h1))/h1;
            y1 = -1i * df(0);
            df2 = @(u) (phi(u+h2) - 2* phi(u) + phi(u-h2)) / h2^2;
            y2 = - real(df2(0));
            df4 = @(u) (df2(u+h3) - 2* df2(u) + df2(u-h3)) / h3^2;
            y3 = real(df4(0));
       end
       
       function phi = cf1(m,u,T,t_star,r,d,params,paramsf,usevec)
            pvec = zeros(1,length(usevec));
            pvec(usevec==true) = params;
            pvec(usevec==false) = paramsf;
            
            phi = m.cf(u,T,t_star,r,d,pvec);                      
       end
    end
    
    methods (Static)
       function phi = cf(u,T,t_star,r,d,params)
            alpha = params(1);
            beta = params(2);
            delta = params(3);
            lambda = params(6);
            kappa = params(4);
            eta = params(5);
            
            lenT = length(T);
            lenU = length(u);
            y0 = 1;

            psiX_u = repmat((-1i) * (-delta)*(sqrt(alpha^2-(beta+1i*u).^2)-sqrt(alpha^2-beta^2)),1,lenT);
            psiX_i = (-1i) * (-delta)*(sqrt(alpha^2-(beta+1)^2)-sqrt(alpha^2-beta^2));

            gamma_u = sqrt(kappa^2-2*lambda^2*1i*psiX_u); %gamma(u) = sqrt(k^2 - 2 lam^2 i u)
            gamma_i = sqrt(kappa^2-2*lambda^2*1i*psiX_i); %gamma(-i)

            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % % Kappung von cosh,sinh,coth um NaN - Warnungen auszuschließen %%%
            x = 0.5*gamma_u*diag(T-t_star);
            
            % acosh(realmax) = 710.4759 = asinh(realmax)
            y1 = cosh(x); y1(x > 710) = realmax; y1(x < -710) = realmax;
            y2 = sinh(x); y2(x>710) = realmax; y2(x<-710) = realmax;
            
            f2_u = repmat((kappa^2*eta*(T-t_star)/(lambda^2)),lenU,1) ...
                -log(y1 + kappa*y2./gamma_u)*(2*kappa*eta*lambda^(-2));    
            
            f3_u = 2*psiX_u./(kappa+gamma_u.*coth(0.5*gamma_u*diag(T-t_star)));                                       

            f1_u = f2_u + log(1-0.5*1i*f3_u*lambda^2/kappa*(1-exp(-kappa*t_star)))*(-2*kappa*eta*lambda^(-2)) ...   
                + 1i*f3_u*y0*exp(-kappa*t_star)./(1-0.5*1i*f3_u*lambda^2/kappa*(1-exp(-kappa*t_star)));

            phi_T = kappa^2*eta*T*lambda^(-2) + 2*y0*1i*psiX_i./(kappa+gamma_i*coth(gamma_i*T/2)) ...               
                    -log( cosh(0.5*gamma_i*T) + kappa*sinh(0.5*gamma_i*T)/gamma_i )*(2*kappa*eta/lambda^2);
            
            if t_star == 0
                phi_tstar = 0;
            else
                phi_tstar = kappa^2*eta*t_star*lambda^(-2)  + 2*y0*1i*psiX_i/(kappa+gamma_i*coth(gamma_i*t_star/2)) ...
                    -log( cosh(0.5*gamma_i*t_star) + kappa*sinh(0.5*gamma_i*t_star)/gamma_i )*(2*kappa*eta/lambda^2);
            end    
                
            phi = exp(repmat(1i*u,1,lenT)*diag((r-d).*(T-t_star)-(phi_T - phi_tstar)) + f1_u);                     
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
    
end
