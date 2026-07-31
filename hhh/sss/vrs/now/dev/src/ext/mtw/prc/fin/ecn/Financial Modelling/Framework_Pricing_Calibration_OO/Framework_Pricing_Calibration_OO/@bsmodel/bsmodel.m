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



classdef bsmodel < model
    
        properties %(SetAccess = 'public', GetAccess = 'public')
            pnparams = [];
            pparams = [];       % this is a struct
            pmarket = '';
            parvec = [];
            usevec = [];
        end


        properties (Constant = true)
            pname = 'Black Scholes';
        end
        
        methods
            function m = bsmodel(params)
                m.pnparams = 1;
                
                m.parvec = ones(1,m.pnparams);
                m.usevec = ones(1,m.pnparams);
            
                m.pparams.sigma = params.sigma;
                
                m.parvec(1) = m.pparams.sigma;
            
                if isfield(params,'usesigma')
                    m.usevec(1) = params.usesigma;
                end
            
            end
        end
        
        methods
            function [y1, y2, y3] = initcumulants(m,T,t_star,r,d,params)
                BS_sigma = params(1);
                y1 = (r-d-0.5*BS_sigma^2).*T;
                y2 = BS_sigma^2*T;
                %m.c4 = 0.0;
                y3 = zeros(length(T),1);
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
                sigma = params(1);
                lenT = length(T);
                phi = exp(repmat(1i*u,1,lenT)*diag((r-d-0.5*sigma^2).*(T-t_star)) - repmat(0.5*sigma^2*u.*u,1,lenT)*diag(T-t_star));
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