% ROWVECH computes veched matrix outproducts
% SYNTAX
%   V=rowvech(sigma,m,n);
% Given vec(sigma_i)' for i=1:N
% returns vech(sigma_i*sigma_i')' for i=1:N
% with the diagonal elements divided by 2
%
% Used by SCSOLVE
% Coded as a C Mex file

% Copyright (c) 2000 by Paul L. Fackler

function V=rowvech(sigma,m,n)
if size(sigma,2)~=m*n
  error('Inputs are incompatible');
end
N=size(sigma,1);
V=zeros(N,m*(m+1)/2);
ind=find(speye(m));
for i=1:N
  temp=reshape(sigma(i,:),m,n); 
  temp=temp*temp';
  temp(ind)=temp(ind)/2;
  V(i,:)=vech(temp)';
end

