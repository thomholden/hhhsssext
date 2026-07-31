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

function [xmin, lambda, mu,iter] = quadOpt(x0,lam0,mue0,Q,c,gam, ...
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

if((feval('gval',x0,A,alfa) <= sqrt(eps)) & (feval('hval',x0,B,beta) == 0)) %Constraints fullfilled
    y = KKT(x0,lam0,mue0,Q,c,B,A,alfa,beta); %x0 KKT point ?
    I = find(abs(A*x0-alfa) <= sqrt(eps)); %Active inequatity Contraints S.1
    while(y == 0) && iter <= maxiter
        tmp = zeros(length(lam0),1);
        if(~isempty(I))
            tmp(I) = lam0(I);
        end
        lam0 = tmp;
        Ak = zeros(length(I),length(alfa));
        Ak = A(I,:);
        [dx,lamAk,mue0] = solveLS(Q,Ak,B,feval('gradf',x0,Q,c)); %Solves Linear System S.2
        lam0(I)=lamAk;
        if(max(abs(dx)) <= sqrt(eps)) %Stopping criteria S.3 (a) dx = 0 lamda >= 0
            if(lam0(I) >= 0)
                y = 1;
                break;
            end
            if(min(lam0(I)) < 0) %S.3 (b) dx = 0 min(lamda < 0)
                q = find(lam0(I)==min(lam0(I)));
                Itmp = zeros(length(I)-1,1);
                Itmp = [I(1:q-1);I(q+1:end)];
                I = Itmp;
            end
        else
            xhat = x0 + dx;
            g = feval('gval',xhat,A,alfa);
            h = feval('hval',xhat,B,beta);
            if(isempty(find(g > sqrt(eps))) && isempty(find(h~= 0)) && isempty(find(xhat < lb)) && isempty(find(xhat > ub)))
                x0 = xhat; %S.3 (c) dx ~= 0 but xk + dx in fullfilles the contraints
            else
                tmp =1:length(alfa); %S.3 (d) dx ~= 0 and xk + dx out of bounds
                if(~isempty(I))
                    for i=1:length(I)
                        Ind = find(tmp~=I(i));
                        tmp = tmp(Ind);
                    end
                end
                s = find(A(tmp,:)*dx > 0);
                tk = (alfa(tmp(s)) - A(tmp(s),:)*x0) ./ (A(tmp(s),:)*dx);
                k = find(tk == min(tk));
                x0 = x0 + tk(k)*dx;
                if(~isempty(I))
                    I(end+1) = tmp(s(k));
                    I = sort(I);
                else
                    I = tmp(s(k));
                end
            end
        end
        y = KKT(x0,lam0,mue0,Q,c,B,A,alfa,beta);
        
        iter = iter + 1;
    end
    xmin = x0;
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
    
tmp = feval('gradf',x,Q,c);
    
gradf = tmp(1:n-m);
ah = tmp(n-m+1:end);
    
DxL = tmp + A'*lam + B'*mue;
    
g = feval('gval',x,A,alfa);
h = feval('hval',x,B,beta);
    
y = 0;
    
eps1 = sqrt(eps);
    
if(max(abs(DxL)) <=eps1)
    if(max(abs(ah-lam(1:m)-lam(m+1:end)))<=eps1)
        if(max(abs(min(-g(1:m),lam(1:m)))) <= eps1)
            if(max(abs(min(-lam(m+1:end),x(n-m+1:end)))) <= eps1)
                y=1;
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