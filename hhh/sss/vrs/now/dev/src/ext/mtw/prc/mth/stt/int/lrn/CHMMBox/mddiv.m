function Z=mddiv(X,Y,dim)
% function Z=mddiv(X,Y,dim)
%
% equivalent of rdiv (row division: Z = X / Y row-wise) 
% for multidimensional arrays. dim is the dimension 
% accross which to divide
%
% example:
%   X=round(10*rand(2,2,2));
%   dim=3;
%   Y=sum(X,3);
%   Z=mddiv(X,Y,dim);
%   disp(sum(Z,3))
%


sv=size(X);
restdim=setdiff(1:length(sv),dim);
restdim=restdim(:)'; dim=dim(:)';

X=permute(X,[restdim,dim]);

sv2=size(X);
X=reshape(X,prod(sv(restdim)),prod(sv(dim)));
Y=reshape(Y,[size(X,1) 1]);  

Z=zeros(size(X));

for i=1:size(X,1),
  Z(i,:)=X(i,:)./Y(i);	
end

Z=reshape(Z,sv2);
Z=ipermute(Z,[restdim,dim]);

