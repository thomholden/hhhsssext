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



function [xMin, fMin,perf] = modSQP(minFunc,x0,ConstraintsFunc,lowerBounds,upperBounds,H0,maxiter,eps1,varargin)
% This function implements a modified and global convergent
% Sequential Quadratic Programming method
% The current version handles inequality and bound constraints

warning('off')

n = length(x0);
x0 = reshape(x0,n,1);

if(nargin < 3 || ...
  (nargin < 4 && isempty(ConstraintsFunc)) || ...
  (nargin < 5 && isempty(ConstraintsFunc) && isempty(lowerBounds)) || ...
  (isempty(ConstraintsFunc) && isempty(lowerBounds) && isempty(upperBounds)))
    error('SQP is designed for constrained problems only.')
end

if nargin >= 4 && ~isempty(lowerBounds)
   lowerBounds = reshape(lowerBounds,n,1); 
end

if nargin >= 5 && ~isempty(upperBounds)
   upperBounds = reshape(upperBounds,n,1); 
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

if(isempty(ConstraintsFunc))
    % bound constraints function
    ConstraintsFunc = @(x)BoundConstraints(x,lowerBounds,upperBounds,varargin{:});
end




%Evaluates the Constraints + Jacobians
[g,Jacg] = feval(ConstraintsFunc,x0);%,varargin{:});
if(~isempty(g))     
    m = length(g);
end

%Evaluates the Function to minimize 
fMin = feval(minFunc,x0,varargin{:});

%Gradient of the Function to minimize
gradf = GradientEval(minFunc,x0,fMin,varargin{:});

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

perf.iter = 0;
perf.itertotal = 0;
perf.xk = [];
perf.fk = [];
tstart = cputime;
oldfval = 2*eps1;
while(abs(fMin-oldfval) > eps1 && (max(abs(gradL)) > eps1 || max(abs(mingl)) > eps1) && perf.iter < maxiter)%Test for KKT-Point and Maximum Iteration Number
   
    
    oldfval = fMin;
    oldGradL = gradL;
    oldX = xk;
    
    perf.xk = [perf.xk xk];
    perf.fk = [perf.fk fMin];
    perf.iter = perf.iter + 1;
    
    %Starting Values of dx = yj and xi
    yj = zeros(n,1);
    xi = max(0,g+Jacg*yj);
    %Solves a quadratic Problem in every Iteration
    [sol,lambda,~,qiter] = quadOpt([yj; xi],lambda,[],[H0 zeros(n,m);zeros(m,m+n)],[gradf; ak*ones(m,1)],0,[Jacg -eye(m,m); zeros(size(Jacg)) -eye(m,m)],[-g-eps; -eps+zeros(m,1)],[],[]);
    perf.itertotal = perf.itertotal + qiter;
    %[sol,~,lambda] = quadOpt1([yj; xi],lambda,[],[H0 zeros(n,m);zeros(m,m+n)],[gradf; ak*ones(m,1)],0,[Jacg -eye(m,m); zeros(size(Jacg)) -eye(m,m)],[-g-eps; -eps+zeros(m,1)],[],[]);
    yj = sol(1:n);
    lamk = lambda(1:m);
    if(max(abs(yj)) <= eps1) %Stopping Criterion dx=0
        fprintf('\nTermination: Residuum dx = xk+1-xk below tol = %e \n\n',eps1)
        break;
    end
    xkk = xk + yj;
    tk = 1.0;
    I = find(xkk-lowerBounds <= 0);
    J = find(xkk-upperBounds >= 0);
    g = feval(ConstraintsFunc,xkk);%,varargin{:});
    K = find(g > 0);
    while(~isempty(I) || ~isempty(J) || ~isempty(K))%Guarantees that x+dx stays in the feasible domain
        %perf.iter = perf.iter + 1;
        tk = tk*beta;
        xkk = xk + tk*yj;
        I = find(xkk < lowerBounds);
        J = find(xkk > upperBounds);
        g = feval(ConstraintsFunc,xkk);%,varargin{:});
        K = find(g > 0);
        if(tk < 1e-10)
            fprintf('\nWarning: Globalization Variable tk to small.\n')
            break;
        end
    end
    
    oldP = fMin + ak*(sum(max(0,g))); %Globalization via Penalty Functions
    
    fMin = feval(minFunc,xkk,varargin{:});
    [g,Jacg]=feval(ConstraintsFunc,xkk);%,varargin{:});
    newP = fMin + ak*(sum(max(0,g)));

    
    while(newP > oldP - sigma*tk*yj'*H0*yj)
        tk = tk*beta;
        xkk = xk + tk*yj;
        if(tk < 1e-10)
            fprintf('\nWarning: Globalization Variable tk to small.\n')
            break;
        end
        %new Function Value
        fMin = feval(minFunc,xkk,varargin{:});
        %new Contraints + Jacobians
        [g,Jacg]=feval(ConstraintsFunc,xkk);%,varargin{:});    
        newP = fMin + ak*(sum(max(0,g)));    
    end
    
    xk = xkk;
    ak = max(ak,max(lamk)+a0);    

    gradf = GradientEval(minFunc,xk,fMin,varargin{:}); %new Gradient of the function to minimize

    gradL = gradf + Jacg'*lamk;

    H0 = HessApprox(oldGradL,oldX,gradL,xk,H0); %Approx the Hessian of the Lagrange Function

    mingl = min(-g,lamk);

    %Stopping criteria
    if(perf.iter == maxiter)
        fprintf('\nTermination: Maximum number of Iteration reached\n')
    end
    
    if(abs(fMin-oldfval) < eps1)
        fprintf('\nTermination: Change in function values from f(xk) to f(xk+1) below tol = %e \n\n',eps1)
    end

end

xMin = xk;
perf.itertotal = perf.iter + perf.itertotal;
perf.totaltime = cputime - tstart;
