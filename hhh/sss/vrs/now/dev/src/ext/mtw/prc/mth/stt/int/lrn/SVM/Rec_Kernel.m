function K=Rec_Kernel(A,B,mu);

[ma,na]=size(A);
[mb,nb]=size(B);
rec=1;
if (ma==nb) 
    if all(all(A==B'))
        K=Gaussian_Kernel(A,mu);
        rec=0;
    end
end    
if rec==1  
    if na~=mb 
        error('non-compatible sizes');
    end
    I=zeros(ma*nb,1);
    p=[1:ma*nb];
    I(p) = mod(p,ma);
    p=[ma:ma:ma*nb];
    I(p)=ma;
    J=zeros(ma*nb,1);
    p=[1:ma:ma*nb];
    J(p)=1;
    J=cumsum(J);
    Y = (A(I,:)-B(:,J)')';
    Y = sum(Y.^2,1);
    K=zeros(ma,nb);
    K(1:ma*nb) = exp(-mu*Y);
end

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Square Gaussian Kernel function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Z=Gaussian_Kernel(X,mu);

[m,n]=size(X);

p = (m-1):-1:2;
I = zeros(m*(m-1)/2,1);
I(cumsum([1 p])) = 1;
I = cumsum(I);
J = ones(m*(m-1)/2,1);
J(cumsum(p)+1) = 2-p;
J(1)=2;
J = cumsum(J);

Y = (X(I,:)-X(J,:))';
Y = sum(Y.^2,1);
Y = exp(-mu*Y);

I = []; J = []; p = [];  % cleaning I J and p.
[m, n] = size(Y);
m = (1 + sqrt(1+8*n))/2;
Z = zeros(m);
I = ones(n,1);
J = [1 (m-1):-1:2]';
I(cumsum(J)) = (2:m);
Z(cumsum(I)) = Y';
Z = Z + Z'+speye(m);

return
