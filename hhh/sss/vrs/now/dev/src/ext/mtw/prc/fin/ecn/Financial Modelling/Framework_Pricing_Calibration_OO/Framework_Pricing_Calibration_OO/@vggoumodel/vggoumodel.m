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



classdef vggoumodel < model
    
    properties
        pnparams = [];
        pparams = [];
        pmarket = '';
        pparams2 = [];
        parvec = [];
        usevec = [];
    end
    
    properties (Constant = true)
        pname = 'VarianceGamma-OU';
    end
    
    methods 
        function m = vggoumodel(params)
            m.pnparams = 6;
            
            m.parvec = ones(1,m.pnparams);
            m.usevec = ones(1,m.pnparams);
            
            m.pparams.c = params.c;
            m.pparams.g = params.g;
            m.pparams.m = params.m;
            m.pparams.a = params.a;
            m.pparams.b = params.b;
            m.pparams.lambda = params.lambda;

            m.parvec(1) = m.pparams.c;
            m.parvec(2) = m.pparams.g;
            m.parvec(3) = m.pparams.m;
            m.parvec(4) = m.pparams.a;
            m.parvec(5) = m.pparams.b;
            m.parvec(6) = m.pparams.lambda;
            
            if isfield(params,'usec') 
                m.usevec(1) = params.usec;
            end
            
            if isfield(params,'useg')
                m.usevec(2) = params.useg;
            end
            
            if isfield(params,'usem')
                m.usevec(3) = params.usem;
            end
            
            if isfield(params,'usea') 
                m.usevec(4) = params.usea;
            end
            
            if isfield(params,'useb') 
                m.usevec(5) = params.useb;
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
       
        function phi = cf1(m,u,T,t_star,r,d, params,paramsf,usevec)
            pvec = zeros(1,length(usevec));
            pvec(usevec==true) = params;
            pvec(usevec==false) = paramsf;
            
            phi = m.cf(u,T,t_star,r,d, pvec);
        end
    end
    
    
    methods (Static)
        function phi = cf(u,T,t_star,r,d, params)
            C = params(1);
            G = params(2);
            M = params(3);
            a = params(4);
            b = params(5);
            lambda = params(6);

            lenT = length(T);

            y0 = 1;
            psiX_u = repmat((-1i)*C*log(G*M./(G*M+(M-G)*1i*u+u.*u)),1,lenT);   %-i psi(u)
            psiX_i = (-1i)*C*log(G*M/(G*M+(M-G)-1));            %-i psi(-i)

            f2_u = 1i*psiX_u*diag(T-t_star)*lambda*a./(lambda*b-1i*psiX_u) ...
                     + a*b*lambda./(b*lambda-1i*psiX_u) ...
                     .*log(1 - 1i*psiX_u/(lambda*b)*diag(1-exp(-(T-t_star)*lambda)));    %f2(-i psi(u)
            f3_u = 1/lambda*psiX_u*diag(1-exp(-lambda*(T-t_star)));                        %f3(-i psi(u)

            f1_u = f2_u + 1i*y0*exp(-lambda*t_star)*f3_u ...
                + a*log((1-1i/b*exp(-lambda*t_star)*f3_u)./(1-1i/b*f3_u));

            phi_T = 1i*psiX_i*y0/lambda*(1-exp(-lambda*T)) ...
                + lambda*a./(1i*psiX_i-lambda*b).*(b*log(b./(b-1i*psiX_i/lambda*(1-exp(-lambda*T))))-1i*psiX_i*T);  %phi_Z(t)(-i)
            phi_tstar = 1i*psiX_i*y0/lambda*(1-exp(-lambda*t_star)) ...
                + lambda*a./(1i*psiX_i-lambda*b).*(b*log(b./(b-1i*psiX_i/lambda*(1-exp(-lambda*t_star))))-1i*psiX_i*t_star); %phi_Z(t)(-i)

            phi = exp(repmat(1i*u,1,lenT)*diag((r-d).*(T-t_star)-(phi_T-phi_tstar)) + f1_u);    %phi_st^*,T(u), s_t^*,T = ln(S_T/S_t^*)
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