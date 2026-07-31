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



function [xMin, fMin] = NelderMead(objfunc,x0,alpha,beta,gamma,varargin)
% Nelder-Mead Downhill simplex for unconstrained problems


    if nargin < 3 || isempty(alpha)
        alpha = 1; % reflection coefficient
    end
    if nargin < 4 || isempty(beta)
        beta = 0.5;  % contraction coefficient
    end
    if nargin < 5 || isempty(gamma)
        gamma = 2.0; % expansion coefficient
    end

    % problem dimension
    N = length(x0);
    
    % 1. initialize the simplex Sk for k = 0
    Sk = repmat(x0,1,N+1);
    Sk(:,2:end) = Sk(:,2:end) + eye(N);
    
    
    % 2. identify the vertices xMin and xMax with
    %    f(v0) <= f(vi) <= f(vn) for all vertices vi, i=0,....,n
    fval = feval(objfunc,Sk,varargin{:});
    
    iter = 0;
    TOL = 1e-14; maxIter = 5000*N;
    %sizeSk = 1;
    
    while iter <= maxIter
    
        % sort function values in ascending order
        [fval,I2] = sort(fval);
        % ordered simplex
        Sk = Sk(:,I2);
        
        v0 = Sk(:,1);
        f0 = fval(1);
        
        fStd = std(fval);
        distv0 = max(max(abs(repmat(v0,1,N)-Sk(:,2:end))));
        if fStd < TOL && distv0 < TOL
            break;
        end
        
        vn = Sk(:,N+1);
        fn = fval(N+1);

        %calculate the centroid over all vertices vi ~= vn
        vhat = mean(Sk(:,1:N),2);

        % 3. Reflection
        xr = vhat*(1 + alpha) - alpha*vn;
        fr = feval(objfunc,xr,varargin{:});

        
        % 4. distinguish the following cases

        % f(xr) < f(v_n-1)
        if fr < fval(N)
            Sk(:,N+1) = xr;
            fval(N+1) = fr;
            % f(xr) < f(v0)
            % => Expansion of xr in direction xr - vhat
            if fr < f0
                xe = vhat*(1 - gamma) + gamma*xr;
                fe = feval(objfunc,xe,varargin{:});
                if fe < fr
                    Sk(:,N+1) = xe;
                    fval(N+1) = fe;
                end    
            end
        else    
            % f(xr) >= f(vn) => partial inner Contraction of vn in
            % direction vhat - vn
            if fr >= fn
                xc = vhat*(1 - beta) + beta*vn;
            else
            % f(v_n-1) <= f(xr) < f(vn) => partial outer
            % Contraction of xr in direction vhat - xr
                xc = vhat*(1 - beta) + beta*xr;
            end

            fc = feval(objfunc,xc,varargin{:});
            if fc < fn
                Sk(:,N+1) = xc;
                fval(N+1) = fc;
            % all tries failed => total Contraction according to v0, that
            % means for all vi ~= v0 set to vi = 0.5*(vi + v0)
            else
                Sk = 0.5*(repmat(v0,1,N+1) + Sk);
                fval = feval(objfunc,Sk,varargin{:});
            end
        end
        
        iter = iter +1;
        
    end
    
    % sort function values in ascending order
    [fval,I2] = sort(fval);
    % ordered simplex
    Sk = Sk(:,I2);
    
    xMin = Sk(:,1);
    fMin = fval(1);
    
    fStd
    distv0
    iter
    
end

