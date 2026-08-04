function [subP,sub]=submdsel(P,Dim,Dimj);
% [subP,sub]=submdsel(P,Dim,j);
%
% extract from a MD array the j-th index of dimension Dim  
% 

sv=size(P);
p=reshape(1:prod(size(P)),size(P));

pv1=setdiff(1:ndims(P),Dim);
pv2=Dim;
pv=[pv1 pv2];
pp=permute(p,pv);
ppp=reshape(pp,prod(sv(pv1)),prod(sv(pv2)));
if length(pv1)==1
  subP=zeros([sv(pv1) 1]);
else
  subP=zeros(sv(pv1));
end
argin=num2cell(Dimj);
if length(pv2)==1
   subDimj=sub2ind([sv(pv2) 1],argin{:});
else
  subDimj=sub2ind(sv(pv2),argin{:});
end
sub=ppp(:,subDimj);
subP(1:end)=P(sub);

