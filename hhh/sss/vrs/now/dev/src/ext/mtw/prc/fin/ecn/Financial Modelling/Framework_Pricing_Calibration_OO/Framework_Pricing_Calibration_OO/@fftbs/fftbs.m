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



classdef fftbs < fftbase
    % classtype: derived class
    %
    % Description: This class uses the characteristic function to
    %              compute the prices of calls, puts or both simultanuously
    %
    % ref1 : Carr, Madan "..."
    % ref2 : Cont, Tankov "..."
    properties
        pN = [];
        peta = [];
        lambda = [];
        b = [];
        ku = [];
        jvec = [];
        vj = [];
        % The member functions (additionally to base class)
        pcharfunc = [];      % characteristic function (model we consider)
        charfuncbs = @cf_bs; % charactersitic function for the Black Scholes model 
        valfunc1 = [];       % valfunction for calls or puts
        valfunc2 = [];       % valfunction is used for simulatanuous pricing of calls and puts
        psigma = [];         % for pricing using BlackScholes adjustment
        palpha = [];
    end
    
    methods (Access = 'public')
        % Constructor
        function ocm = fftbs(N,eta, alpha, sigma, model)
            ocm.pN = 2^N;                               % from base  
            ocm.peta = eta;                 
            charfunc = @(u,T,t_star,r,d,p) ...
                model.cf1(u,T,t_star,r,d,p,model.parvec(model.usevec==false),model.usevec);
 
            ocm.lambda = (2 * pi) / (ocm.pN * ocm.peta);  % spacing for log strike output (23)
            ocm.b = (ocm.pN * ocm.lambda) / 2;           % eqn (20) from ref1
            uvec = (1:ocm.pN)';
            ocm.ku = - ocm.b + ocm.lambda * (uvec - 1); % eqn (19) from ref1
            ocm.jvec = (1:ocm.pN)';
            ocm.vj = (ocm.jvec-1) * ocm.peta;
            ocm.psigma = sigma;
            ocm.palpha = alpha;
            ocm.pcharfunc = charfunc;
            % Version without Black-Scholes adjustment, see ref1
            ocm.valfunc1 = ...
                @(T, t, r, d, params) ...
                    (feval(ocm.pcharfunc,ocm.vj - (ocm.palpha + 1) * 1i, T,t,r,d, params)- ...
                     feval(ocm.charfuncbs, ocm.vj - (ocm.palpha+1) * 1i, T, t, r,d, ocm.psigma))./ ...
                        repmat(ocm.palpha^2 + ocm.palpha - ocm.vj.^2 + 1i * (2 * ocm.palpha + 1) * ocm.vj,1,length(T));
            % ocm.valfunc1 = ...
            %    @(T, t, r, d, params) ...
            %        (feval(ocm.pcharfunc,ocm.vj - (ocm.palpha + 1) * 1i, T,t,r,d, params)- ...
            %         feval(ocm.cfbs, ocm.vj - (ocm.palpha+1) * 1i, T, t, r,d, ocm.psigma))./ ...
            %            repmat(ocm.palpha^2 + ocm.palpha - ocm.vj.^2 + 1i * (2 * ocm.palpha + 1) * ocm.vj,1,length(T));
        end

        function y = price(ocm, T, t, S0, d, df, params,dataK,cp)
            
            lenK = length(dataK);
            lenT = length(T);
            
            %continuously compunded riskfree rate
            r = -log(df)./T;
            % computes a range of option prices (calls / puts); cp = 1
            % (Call), cp = 0 (Put)
            ret = ocm.valfunc1(T,t,r,d,params);
            tmp = (ret.*exp(1i * repmat(ocm.vj,1,lenT)* ocm.b))*diag(df) * ocm.peta;
            tmp(isnan(tmp)) = max(max(tmp));

            tmp = (tmp / 3) .* repmat((3 + (-1).^ocm.jvec - ((ocm.jvec - 1) == 0) ),1,lenT); 

            cpmat = real(repmat(exp(-ocm.palpha * ocm.ku),1,lenT) .* fft(tmp) / pi); 

            Ktmp = repmat(dataK,1,lenT);
            Ttmp = repmat(T,lenK,1);
            Rtmp = repmat(r,lenK,1);
            tmp =  blsprice(1,Ktmp, Rtmp,Ttmp-t,ocm.psigma,d);

            indexset = repmat(cp',length(T),1);
            
            y = exp(-d*t)*S0*(repmat(exp(r*t),lenK,1).*real(interp1(ocm.ku,cpmat,log(dataK)))+ tmp);
            y1 = y + exp(-d*t)*S0*(repmat(dataK,1,lenT).* repmat(exp(-r.*(T-t)),lenK,1) ...
                - repmat(exp(-d*(T-t)),lenK,1));
           
            y(indexset == 0) = y1(indexset == 0);
            % due to numerical issues we have to take care of imag
            % values
            y(abs(imag(y))>0) = realmax;
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


        function y = cf_bs(u,T,t_star,r,d,params)
            sigma = params(1);
            lenT = length(T);
            y = exp(repmat(1i*u,1,lenT)*diag((r-d-0.5*sigma^2).*(T-t_star)) - repmat(0.5*sigma^2*u.*u,1,lenT)*diag(T-t_star));
        end