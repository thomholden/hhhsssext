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



classdef nigmodel < model
    
    properties
        pnparams = [];
        pparams = [];
        pmarket = '';
        parvec = [];
        usevec = [];
    end
    
    properties (Constant = true)
        pname = 'Normal Inverse Gaussian';
    end
    
    methods
        function m = nigmodel(params)
            m.pnparams = 3;
            
            m.parvec = ones(1,m.pnparams);
            m.usevec = ones(1,m.pnparams);
            
            m.pparams.alpha = params.alpha;
            m.pparams.beta = params.beta;
            m.pparams.delta = params.delta;

            m.parvec(1) = m.pparams.alpha;
            m.parvec(2) = m.pparams.beta;
            m.parvec(3) = m.pparams.delta;
            
            if isfield(params,'usealpha')
                m.usevec(1) = params.usealpha;
            end
            
            if isfield(params,'usebeta')
                m.usevec(2) = params.usebeta;
            end
            
            if isfield(params,'usedelta')
                m.usevec(3) = params.usedelta;
            end
            
        end
    end
    
    methods
        function [y1, y2, y3] = initcumulants(m,T,t_star,r,d,params)
        % computes the cumulants for given T, r and d
            alpha = params(1);
            beta = params(2);
            delta = params(3);
            phiXi = (-delta)*(sqrt(alpha^2-(beta+1)^2)-sqrt(alpha^2-beta^2));
            y1 = (r-d - phiXi + delta*beta/sqrt(alpha^2-beta^2)).*T;
            y2 = (alpha^2*delta/sqrt(alpha^2-beta^2)^3).*T;
            y3 = 3*(alpha^2*delta*(alpha^2+4*beta^2)/sqrt(alpha^2-beta^2)^7).*T;
        end
        
        function phi = cf1(m,u,T,t_star,r,d,params,paramsf,usevec)
            pvec = zeros(1,length(usevec));
            pvec(usevec==true) = params;
            pvec(usevec==false) = paramsf;
            
            phi = m.cf(u,T,t_star,r,d, pvec);
        end 
    end
    
    methods (Static)
        function phi = cf(u,T,t_star,r,d, params)
            alpha = params(1); beta = params(2); delta=params(3);
            lenT = length(T);
            phiX_u = (-delta)*(sqrt(alpha^2-(beta+1i*u).^2)-sqrt(alpha^2-beta^2));
            phiX_i = (-delta)*(sqrt(alpha^2-(beta+1)^2)-sqrt(alpha^2-beta^2));
            phi_nig = repmat(1i*u,1,lenT)*diag((r-d-phiX_i).*(T-t_star)) + repmat(phiX_u,1,lenT)*diag(T-t_star);
            phi = exp(phi_nig);
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


        