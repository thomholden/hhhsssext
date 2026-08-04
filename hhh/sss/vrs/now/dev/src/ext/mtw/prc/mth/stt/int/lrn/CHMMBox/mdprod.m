function Z=mdprod(X,Y,dim)
% function Z=mdprod(X,Y,dim)
%
% equivalent of rdiv (row multiplication: Z = X * Y row-wise) 
% for multidimensional arrays
% note: these routines are NOT fully tested
%
% example:
% X=round(10*rand(2,2,2));
% dim=3;
% Y=mdsum(X,dim);
% Z=mdprod(X,Y,dim);
%


sv=size(X);
restdim=setdiff(1:length(sv),dim);
restdim=restdim(:)'; dim=dim(:)';
X=permute(X,[restdim,dim]);
sv2=size(X);
X=reshape(X,prod(sv(restdim)),prod(sv(dim)));
Y=reshape(Y,[prod(size(Y)) 1]);  

Z=zeros(size(X));

for i=1:size(X,2),
  Z(:,i)=X(:,i).*Y(i);	
end

Z=reshape(Z,sv);


