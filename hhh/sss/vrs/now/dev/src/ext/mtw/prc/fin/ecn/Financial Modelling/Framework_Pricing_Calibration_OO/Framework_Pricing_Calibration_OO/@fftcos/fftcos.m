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



classdef fftcos
    % classtype: derived class
    %
    % Description: This class uses the characteristic function to
    %              compute the prices of calls, puts or both simultanuously
    %
    % ref1 : Fang, Oosterlee, "A Novel Pricing Method for European Options based on
    %                          Fourier-Cosine series expansions"
    properties
        N = [];
        L = [];
        model = [];
        uvec = [];
        % The member functions (additionally to base class)%
        pcharfunc = [];
        c1 = [];
        c2 = [];
        c4 = [];
    end
    
    methods (Access = 'public')
        % Constructor
        function ocm = fftcos(N,L,model)
            ocm.N = 2^N;                               % from base  
            ocm.L = L;
            ocm.model = model;
            charfunc = @(u,T,t_star,r,d,p) ...
                model.cf1(u,T,t_star,r,d,p,model.parvec(model.usevec==false),model.usevec);
            ocm.uvec = (0:ocm.N-1)'*pi;
            ocm.pcharfunc = charfunc;
            
            % this will be placed into a model class later!

        end
        
        function y = price(ocm, T, t, S0, d, df, params,dataK,cp)
            
            lenK = length(dataK);
            lenT = length(T);
            
            %continuously compunded riskfree rate
            r = -log(df)./T;
            
            % computes a range of option prices (calls / puts); cp = 1
            % (Call), cp = -1 (Put)
            pvec = ocm.model.parvec; %zeros(1,length(usevec));
            pvec(ocm.model.usevec==true) = params;
            [ocm.c1, ocm.c2, ocm.c4] = ocm.model.initcumulants(T,t,-log(df)./T,d,pvec);
            
            x = -log(dataK);
            
            % truncation range
            y = ones(lenT,lenK); 
            for u=1:lenT
                lbound = real(max(-5,ocm.c1(u) - ocm.L*sqrt(abs(ocm.c2(u)) + sqrt(abs(ocm.c4(u))))));
                ubound = real(min(max(ocm.c1(u) - lbound,0),5));
                %lbound = ocm.c1(u) - ocm.L*sqrt(abs(ocm.c2(u)) + sqrt(abs(ocm.c4(u))));
                %ubound = 2*ocm.c1(u) - lbound;
                
                uvect = ocm.uvec/(ubound - lbound);

                x1 = lbound; x2 = 0;
            
                tmp1 = (x2-lbound)*uvect;
                tmp2 = (x1-lbound)*uvect;

                exp_x1 = exp(x1);
                exp_x2 = exp(x2);

                chi = ( cos(tmp1)*exp_x2 - cos(tmp2)*exp_x1 + uvect.*(sin(tmp1)*exp_x2-sin(tmp2)*exp_x1) ) ./ ( 1 + uvect.^2 );
                
                psi = (sin(tmp1)-sin(tmp2)) ./ uvect;
                psi(1) = x2-x1;

                V_k = -2*(chi-psi)/(ubound-lbound);
                
                mat1 = (uvect * ones(1,lenK))';
                mat2 = (x-lbound)*ones(1,ocm.N);   
                mat = exp(1i * (mat1.*mat2));
                mat(:,1) = 0.5*mat(:,1);
                y(u,:) = exp(-d*t)*exp(-r(u)*(T(u)-t))*S0* dataK .* real(mat * (ocm.pcharfunc(uvect,T(u),t,r(u),d,params).*V_k));
            end
            y = y';
            indexset = repmat(cp',1,lenT);
            y1 = y + exp(-d*t)*(-repmat(exp(-r.*(T-t)),lenK,1).*repmat(S0*dataK,1,lenT)...
                + repmat(S0*exp(-d*(T-t)),lenK,1)); 

            y(indexset == 1) = y1(indexset == 1);
            % numerical evaluation of cumulants can cause severe
            % problems. To this end we need to take care of imag and
            % NaN values
            y(abs(imag(y))>0 | isnan(y)) = 1000;
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