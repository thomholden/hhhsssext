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



classdef mjmodel < model
    
        properties %(SetAccess = 'public', GetAccess = 'public')
            pnparams = [];
            pparams = [];       % this is a struct
            pmarket = '';
            parvec = [];
            usevec = [];
        end


        properties (Constant = true)
            pname = 'Merton Jump';
        end
        
        methods
            function m = mjmodel(params)
                m.pnparams = 4;
                
                m.parvec = ones(1,m.pnparams);
                m.usevec = ones(1,m.pnparams);
            
                m.pparams.sigma = params.sigma;
                m.pparams.alpha_j = params.alpha_j;
                m.pparams.sigma_j = params.sigma_j;
                m.pparams.lambda = params.lambda;
                
                m.parvec(1) = m.pparams.sigma;
                m.parvec(2) = m.pparams.alpha_j;
                m.parvec(3) = m.pparams.sigma_j;
                m.parvec(4) = m.pparams.lambda;
            
                if isfield(params,'usesigma')
                    m.usevec(1) = params.usesigma;
                end
          
                if isfield(params,'usealpha_j')
                    m.usevec(2) = params.usealpha_j;
                end

                if isfield(params,'usesigma_j')
                    m.usevec(3) = params.usesigma_j;
                end
                
                if isfield(params,'uselambda')
                    m.usevec(4) = params.uselambda;
                end
            
            end
        end
        
        methods
            function [y1, y2, y3] = initcumulants(m,T,t_star,r,d,params)
                sigma = params(1); alpha_j = params(2);
                sigma_j = params(3); lambda = params(4);
                y1 = (r-d + lambda*alpha_j - 0.5*sigma^2).*T;
                y2 = (lambda*(sigma_j^2+alpha_j^2)+sigma^2).*T;
                y3 = (lambda*(3*sigma_j^2*(sigma_j^2+2*alpha_j^2)+alpha_j^4)).*T;
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
                sigma_mj = params(1); alpha_j = params(2); sigma_j=params(3); lambda = params(4);
                lenT = length(T);

                phiD_u = -0.5*sigma_mj^2*u.*u;
                phiD_i = 0.5*sigma_mj^2;
                phiJ_u = lambda*(exp(1i*u*alpha_j-0.5*u.*u*sigma_j^2)-1);
                phiJ_i = lambda*(exp(alpha_j+0.5*sigma_j^2)-1);

                phiX_u = phiD_u + phiJ_u;
                phiX_i = phiD_i + phiJ_i;
                phi_mj = repmat(1i*u,1,lenT)*diag((r-d-phiX_i).*(T-t_star))  + repmat(phiX_u,1,lenT)*diag(T-t_star);

                phi = exp(phi_mj);
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
                