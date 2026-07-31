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



function [dx,lam,mue] = solveLS(Q,Ak,B,gradf)


if(isempty(Ak) | Ak == 0) 
    m = 0;
else
    m = length(Ak(:,1));
end
if(isempty(B) | B == 0) 
    p = 0;
else
    p = length(B(:,1));
end

n = length(Q(:,1));

if(p == 0)
    if(m == 0)
        Mat = Q;
        vec = gradf;
    else
        %m = length(Ak(:,1));
        Mat = zeros(n+m,n+m);
        Mat(1:n,n+1:end) = Ak';
        Mat(:,1:n) = [Q; Ak];
        vec = zeros(n+m,1);
    end
else
    %p = length(B(:,1));
    if(m==0)
        Mat = zeros(n+p,n+p);
        Mat(1:n,n+1:end) = B';
        Mat(:,1:n) = [Q; B];
        vec = zeros(n+p,1);
    else
        %m = length(Ak(:,1));
        Mat = zeros(n+m+p,n+m+p);
        Mat(1:n,n+1:end) = [Ak' B'];
        Mat(:,1:n) = [Q; Ak; B];
        vec = zeros(n + m + p,1);
    end
end
vec(1:n) = -gradf;
if(eig(Mat) > 0)
    [L,D] = Cholesky(Mat);
    tmp = ForwardSubstitution(L,vec);
    sol = BackwardRecursion(L',tmp);
else
    sol = Mat \ vec;
end

dx = sol(1:n);
lam = sol(n+1:n+m);
mue = sol(n+m+1:end);