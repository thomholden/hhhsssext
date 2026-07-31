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



function [pmin, minf,vecX] = modifiedSQP(minFunc,x0,ConstraintsFunc,lowerBounds,upperBounds,H0,maxiter,eps1,varargin)

warning off

% global maxAbsError;
% global minAbsError;
% global averageAbsError;

n = length(x0);

if(nargin < 3 || isempty(ConstraintsFunc))
    % trivial constraints function
    ConstraintsFunc = @(x)BoundConstraints(x,lowerBounds,upperBounds);
end

if(nargin < 4 || isempty(lowerBounds))
    %trivial lower bounds
    lowerBounds = -Inf*ones(n,1);
end
if(nargin < 5) || isempty(upperBounds)
    %trivial upper bounds
    upperBounds = Inf*ones(n,1);
end

if(nargin < 6 || isempty(H0))
    %initial Hessian
    H0 = eye(n);
end

if(nargin < 7 || isempty(maxiter))
    %Maximum Iteration Number
    maxiter = n*100;
end

if(nargin < 8 || isempty(eps1))
    eps1 = n*sqrt(eps);
end

%Evaluates the Constraints + Jacobians
[g,Jacg,h,Jach] = feval(ConstraintsFunc,x0,varargin{:});
if(~isempty(g))     
    m = length(g);
end
if(~isempty(h))
    p = length(h);
end

%Evaluates the Function to minimize 
minf = feval(minFunc,x0,varargin{:});
% if(abs(minf) < 1e-6)
%     pmin = x0;
%     fprintf('\nCalibrated Parameters\n'); 
%     disp(pmin);
%     fprintf('\nMaximum absolute Error in percent: %f\n',maxAbsError);
%     fprintf('\nMinimum absolute Error in percent: %f\n',minAbsError);
%     fprintf('\nAverage absolute Error in percent: %f\n',averageAbsError);
%     return;
% end


%Gradient of the Function to minimize
gradf = GradientEval(minFunc,x0,minf,varargin{:});

%H0 = InitialHessian(minFunc,x0,minf,varargin{:});

%Largrange Multipliers
if isempty(g)
    lam0 = [];
else
    lam0 = zeros(m,1);
end

%Gradient of the Lagrange Function 
gradL = gradf + Jacg'*lam0;
mingl = min(-g,lam0);

%Constants used by the algorithm
a0 = 1e+6;
ak = a0;
beta = 0.5;
sigma = 0.2;

lambda = [lam0;zeros(m,1)];
xk = x0;

iter = 0;

if(iter==maxiter)
    fprintf('\nTermination: Maximum number of Iteration reached\n')
end

vecX = [];
oldfval = 2*eps1;
while(abs(minf-oldfval) > eps1 && (max(abs(gradL)) > eps1 || max(abs(mingl)) > eps1) && iter < maxiter)%Test for KKT-Point and Maximum Iteration Number
   
    iter = iter+1;
    
    oldfval = minf;
    oldGradL = gradL;
    oldX = xk;
    
    vecX = [vecX xk];
    
    %Starting Values of dx = yj and xi
    yj = zeros(n,1);
    xi = max(0,g+Jacg*yj);
    %Solves a quadratic Problem in every Iteration
%     [sol,~,lambda, mu] = quadOpt1([yj; xi],lambda,[],[H0 zeros(n,m);zeros(m,m+n)],[gradf; ak*ones(m,1)],0,[Jacg -eye(m,m); zeros(size(Jacg)) -eye(m,m)],[-g-eps; -eps+zeros(m,1)],[],[]);
    [sol,lambda, mu] = quadOpt([yj; xi],lambda,[],[H0 zeros(n,m);zeros(m,m+n)],[gradf; ak*ones(m,1)],0,[Jacg -eye(m,m); zeros(size(Jacg)) -eye(m,m)],[-g-eps; -eps+zeros(m,1)],[],[]);
    yj = sol(1:n);
    lamk = lambda(1:m);
    if(max(abs(yj)) <= eps1) %Stopping Criterium dx=0
        fprintf('\nTermination: Residuum dx = xk+1-xk below tol = %e \n\n',eps1)
        break;
    end
    xkk = xk + yj;
    tk = 1.0;
    I = find(xkk-lowerBounds <= 0);
    J = find(xkk-upperBounds >= 0);
    [g,Jacg,h,Jach]=feval(ConstraintsFunc,xkk,varargin{:});
    K = find(g > 0);
    while(~isempty(I) || ~isempty(J) || ~isempty(K))%Assures that x+dx stays in the definition domain
        iter = iter + 1;
        tk = tk*beta;
        xkk = xk + tk*yj;
        I = find(xkk < lowerBounds);
        J = find(xkk > upperBounds);
        [g,Jacg,h,Jach]=feval(ConstraintsFunc,xkk,varargin{:});
        K = find(g > 0);
        if(tk < 1e-10)
            fprintf('\nWarning: Globalization Variable tk to small.\n')
            pmin = xkk;
            return;
        end
    end
    
    oldP = minf + ak*(sum(max(0,g))); %Globalization via Penalty Functions
    
    minf = feval(minFunc,xkk,varargin{:});
    [g,Jacg,h,Jach]=feval(ConstraintsFunc,xkk,varargin{:});
    newP = minf + ak*(sum(max(0,g)));

    
    while(newP > oldP - sigma*tk*yj'*H0*yj)
        tk = tk*beta;
        xkk = xk + tk*yj;
        if(tk < 1e-10)
            fprintf('\nWarning: Globalization Variable tk to small.\n')
            pmin = xkk;
            return;
        end
        %new Function Value
        minf = feval(minFunc,xkk,varargin{:});
        %new Contraints + Jacobians
        [g,Jacg,h,Jach]=feval(ConstraintsFunc,xkk,varargin{:});    
        newP = minf + ak*(sum(max(0,g)));    
    end
    
    xk = xkk;
    ak = max(ak,max(lamk)+a0);    

    gradf = GradientEval(minFunc,xk,minf,varargin{:}); %new Gradient of the function to minimize

    gradL = gradf + Jacg'*lamk;

    H0 = HessApprox(oldGradL,oldX,gradL,xk,H0); %Approx the Hessian of the Lagrange Function

    mingl = min(-g,lamk);

    %Stopping criteria
    if(iter==maxiter)
        fprintf('\nTermination: Maximum number of Iteration reached\n')
    end
    
    if(abs(minf-oldfval) < eps1)
        fprintf('\nTermination: Change in function values from f(xk) to f(xk+1) below tol = %e \n\n',eps1)
    end

%     fprintf('\nCalibrated Parameters p =\n'); 
%     disp(xk);
    
%     if ~isempty(maxAbsError)
%         fprintf('\nMaximum absolute Error in percent: %f\n',maxAbsError);
%         fprintf('\nMinimum absolute Error in percent: %f\n',minAbsError);
%         fprintf('\nAverage absolute Error in percent: %f\n',averageAbsError);
%     end
% %     fprintf('\nFunction Value minf = %f\n', minf);
%     if(abs(minf) < 1e-6)
%         break;
%     end

end

pmin = xk;

% fprintf('\nCalibrated Parameters p =');
% disp(pmin)
% fprintf('\nFunction Value minf = %f\n', minf);
% fprintf('\n-----------------------------------\n')

clear global
