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



classdef vgmodel < model
    
    properties
        pnparams = [];  % number of model parameters
        pparams = [];   % parameter of the model
        pparams2 = [];  % for vg the subordinated diff version
        pmarket = '';   % market where model is applied
        
        parvec = [];    % used for calibration
        usevec = [];    % used for calibration
        
        cgm = [];       % input is cgm or subordinated
    end
    
    properties (Constant = true)
        pname = 'VarianceGamma';
    end
    
    methods 
        function m = vgmodel(params)
            m.pnparams = 3;
            
            m.parvec = ones(1,m.pnparams);
            m.usevec = ones(1,m.pnparams);
            
            m.cgm = params.cgm;
            
            if (params.cgm == true)
                m.pparams.c = params.c;  
                m.pparams.g = params.g;  
                m.pparams.m = params.m;

                % calculate parameters for subordination representation
                m.pparams2.nu = 1/params.c;
                m.pparams2.theta = (1/params.m-1/params.g)/m.pparams2.nu;
                m.pparams2.sigma = sqrt(((1/params.g+m.pparams2.theta*m.pparams2.nu/2)^2-m.pparams2.theta^2*m.pparams2.nu^2/4)*2/m.pparams2.nu);
            else
                m.pparams2.nu = params.nu;
                m.pparams2.theta = params.theta;
                m.pparams2.sigma = params.sigma;
                
                % calculate parameters for c, g, m representation
                m.pparams.c = 1/nu;
                m.pparams.g = 1/(sqrt(0.25*theta^2*nu^2+0.5*sigma^2*nu)-0.5*theta*nu);
                
                m.pparams.m = 1/(sqrt(0.25*theta^2*nu^2+0.5*sigma^2*nu)+0.5*theta*nu);
            end
            
            m.parvec(1) = m.pparams.c;
            m.parvec(2) = m.pparams.g;
            m.parvec(3) = m.pparams.m;
            
            if isfield(params,'usec')
                m.usevec(1) = params.usec;
            elseif isfield(params,'usenu')
                    m.usevec(1) = params.usenu;
            end
            
            if isfield(params,'useg')
                m.usevec(2) = params.useg;
            elseif isfield(params,'usetheta')
                    m.usevec(2) = params.usetheta;
            end

            
            if isfield(params,'usem')
                m.usevec(3) = params.usem;
            elseif isfield(params,'usesigma')
                m.usevec(3) = params.usesigma;
            end
            
            
        end
       
    end
    methods
        function [y1, y2, y3] = initcumulants(m,T,t_star,r,d,params)
         % computes the cumulants for given T, r and d 
            
%             nu = 1/params(1);
%             theta = (1/params(3)-1/params(2))/nu;
%             sigma = sqrt(((1/params(2)+theta*nu/2)^2-theta^2*nu^2/4)*2/nu);
%                 
%             phiX_i = params(1)*log(params(2)*params(3)./(params(2)*params(3) ...
%                 +(params(3)-params(2))-1));
%             
%             y1 = (r-d - phiX_i + theta).*T;
%             y2 = (sigma^2+nu*theta^2).*T;
%             y3 = 3*(sigma^4*nu+2*nu^3*theta^4+4*sigma^2*theta^2*nu^2).*T;

            C = params(1); G = params(2); M = params(3);

            phiX_i = C*log(G*M./(G*M+(M-G)-1));
            
            y1 = (r-d - phiX_i + (C*(G - M))/(G*M)).*T;
            y2 = C*(1/G^2 + 1/M^2)*T;
            y3 = 6*C*(1/G^4 + 1/M^4)*T;

        end
        
        function phi = cf1(m,u,T,t_star,r,d, params,paramsf,usevec)
        % characteristic function for fixed and variable parameter sets
        % useful for calibration to a given set of parameter
        
            pvec = m.parvec; %zeros(1,length(usevec));
            pvec(usevec==true) = params;
            pvec(usevec==false) = paramsf;
            
            phi =  m.cf(u,T,t_star,r,d,pvec);    
        end
    end
    methods (Static)
        function phi = cf(u,T,t_star,r,d, params)
        % characteristic function for full parameter set (standard)
        % The cf is always in cgm form
            lenT = length(T);
            C = params(1); G = params(2); M=params(3);
            phiX_u = C*log(G*M./(G*M+(M-G)*1i*u+u.*u));
            phiX_i = C*log(G*M./(G*M+(M-G)-1));
            tmp = repmat(1i*u,1,lenT)*diag((r-d-phiX_i).*(T-t_star));
            phi =  exp(tmp + repmat(phiX_u,1,lenT)*diag(T-t_star));
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



