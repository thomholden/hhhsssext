function [sLagOpSpec,flag]=sortLagOpSpec(LagOpSpec);
%  LagOpSpec=sortLagOpSpec(LagOpSpec); 
%  
% Sort lag indeces in LagOperator in ascending order, i.e. Lags begin with most
% negative first
% E.g. This
%       LagOpSpec{1}: [-1 -1 -3; 1 2 2];
%       LagOpSpec{2}: [-1 -4 -1; 1 1 2]}
% becomes
%       LagOpSpec{1}: [-1 -3 -1; 1 2 2];
%       LagOpSpec{2}: [-4 -1 -1; 1 1 2]}
%
%
 
flag=0;
sLagOpSpec=LagOpSpec;

for c=1:length(LagOpSpec), 
  uc=unique(LagOpSpec{c}(2,:));
  for l=1:length(uc) 
    ndx=find(LagOpSpec{c}(2,:)==uc(l));
    if length(ndx)>1 & uc(l)==c, flag=1; end;
    sLagOpSpec{c}(1,ndx)=sort(LagOpSpec{c}(1,ndx));
    sLagOpSpec{c}(2,ndx)=LagOpSpec{c}(2,ndx);
  end;
end 


