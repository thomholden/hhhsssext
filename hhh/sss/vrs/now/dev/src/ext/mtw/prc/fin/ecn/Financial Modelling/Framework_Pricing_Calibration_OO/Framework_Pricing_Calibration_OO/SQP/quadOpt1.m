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



%-------------------------------------------
% min f(x) = 0.5*x'*Q*x + c'*x + gam
%
%       bj'*x = betaj   (j = 1,...,p)
%       ai'*x <= alfai  (i = 1,...,m)
%--------------------------------------------
%   f:R^n -> R
%   Q in R^nxn symmetric + positive definite
%   c in R^nx1
%   gam in R

function [xmin, fmin, lambda, mu] = quadOpt1(x0,lam0,mue0,Q,c,gam, ...
                                        A,alfa,B,beta,lb,ub, ...
                                        maxiter)

m = length(x0);

if(nargin < 6)
    gam = 0;
end
if(nargin < 7 || isempty(A))
    A = zeros(1,m);
end
if(nargin < 8 || isempty(alfa))
    alfa = zeros(length(A(:,1)),1);
end
if(nargin < 9 || isempty(B))
    B = zeros(1,m);
end
if(nargin < 10 || isempty(beta))
    beta = zeros(length(B(:,1)),1);
end
if(nargin < 11)
    lb = -Inf*ones(m,1);
end
if(nargin < 12)
    ub = Inf*ones(m,1);
end
if(nargin < 13)
    maxiter = m*100;
end


if(isempty(mue0))
    mue0 = zeros(length(beta),1);
end
if(isempty(lam0))
    lam0 = zeros(length(alfa),1);
end

iter = 1;
eps1 = sqrt(eps);

if max(gval(x0,A,alfa)) <= eps1 && norm(hval(x0,B,beta),inf) <= eps1 %Constraints fullfilled
    y = KKT(x0,lam0,mue0,Q,c,B,A,alfa,beta); %x0 KKT point ?
    I = abs(A*x0-alfa) <= eps1; %index of Active inequatity Contraints S.1
    while y == 0 && iter <= maxiter
        lam0(~I) = 0;
        Ak = A(I,:);
        [dx,lamAk,mue0] = solveLS(Q,Ak,B,gradf(x0,Q,c)); %Solves Linear System S.2
        lam0(I) = lamAk;
        if norm(dx,inf) <= eps1 %Stopping criteria S.3 (a) dx = 0 lamda >= 0
            if lam0(I) >= 0
                break;
            else %S.3 (b) dx = 0 min(lamda) < 0
                Itmp = lam0 ~= min(lam0(lam0 < 0));
                I = I & Itmp;
            end
        else
            xhat = x0 + dx;
            g = gval(xhat,A,alfa);
            h = hval(xhat,B,beta);
            if sum(g > eps1) == 0 && sum(norm(h,inf) > eps1) == 0 && sum(xhat < lb + eps1) == 0 && sum(xhat > ub - eps1) == 0
                x0 = xhat; %S.3 (c) dx ~= 0 but xk + dx in fullfilles the contraints
            else

                tk = (alfa - A*x0) ./ (A*dx);
                Itmp = tk == min(tk(A(~I,:)*dx > 0));
                x0 = x0 + tk(Itmp)*dx;

                % update used constraints indices
                I = I | Itmp;
            end
        end
        y = KKT(x0,lam0,mue0,Q,c,B,A,alfa,beta);

        iter = iter + 1;
    end
    xmin = x0;
    fmin = fval(x0,Q,c,gam);
    lambda = lam0;
    mu = mue0;

else
    fprintf('x0 out of limits');
end
    
end
%-----------------------------------------------

function y = fval(x,Q,c,gam)
%   f(x) = 0.5*x'*Q*x + c'*x + gam
    y = 0.5*x'*Q*x + c'*x + gam;
end
%-----------------------------------------------

function y = KKT(x,lam,mue,Q,c,B,A,alfa,beta)

m = length(alfa)/2;
n = length(x);
if(isempty(mue))
    mue = 0;
end
    
tmp = gradf(x,Q,c);
ah = tmp(n-m+1:end);
    
DxL = tmp + A'*lam + B'*mue;
    
g = gval(x,A,alfa);
h = hval(x,B,beta);
    
y = 0;
    
eps1 = sqrt(eps);
    
if norm(DxL,inf) <= eps1
    if norm(h,inf) <= eps1
        if norm(ah-lam(1:m)-lam(m+1:end),inf) <= eps1
            if norm(min(-g(1:m),lam(1:m)),inf) <= eps1
                if norm(min(-lam(m+1:end),x(n-m+1:end)),inf) <= eps1
                    y = 1;
                end
            end
        end
    end
end

end
%-------------------------------------------------

function y = gradf(x,Q,c)
%   gradf(x) = Q*x + c
    y = Q*x + c;
end    
%-----------------------------------------------

function h = hval(x,B,beta)
%   hj(x) = bj'*x - beta = 0 ?
    h = B*x - beta;
end    
%------------------------------------------------

function g = gval(x,A,alfa)
%   gi(x) = ai'*x - alfa <= 0 ?
    g = A*x - alfa;
end
%-------------------------------------------------