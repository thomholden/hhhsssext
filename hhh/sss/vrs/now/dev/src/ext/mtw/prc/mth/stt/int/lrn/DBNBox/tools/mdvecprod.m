function [P]=mdvecprod(P,Pi,Dim,mflag);
% [P]=mdvecprod(P,Pi,Dim,mflag);
%
% multiply a MD array by a vector along dimension Dim  
% with optional marginalisation over dimension Dim

sv=size(P);
p=reshape(1:prod(size(P)),size(P));

pv1=setdiff(1:ndims(P),Dim);
pv2=Dim;
pv=[pv1 pv2];
pp=permute(p,pv);
ppp=reshape(pp,prod(sv(pv1)),prod(sv(pv2)));
P(ppp)=P(ppp).*repmat(Pi(:)',size(ppp,1),1);

%and if marginal
if nargin<4 | mflag,
  P=squeeze(sum(P,Dim));
end

