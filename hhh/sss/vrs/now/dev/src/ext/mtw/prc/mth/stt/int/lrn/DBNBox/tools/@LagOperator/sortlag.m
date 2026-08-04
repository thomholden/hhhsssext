function [sLagOp,usi]=sortlag(LagOp);
%  LagOp=sortlag(LagOp); 
%  
% Sort lag indeces in LagOperator in ascending order, i.e. Lags begin with most
% negative first
% E.g. This
%       Lag: {[-1 -1 -3]  [-1 -4 -1]}
%       Cha: {[0 1 1]  [-1 -1 0]}
% becomes
%       Lag: {[-1 -3 -1]  [-4 -1 -1]}
%       Cha: {[0 1 1]  [-1 -1 0]}
%
%
 

sLagOp=LagOp;
usi=cell(length(LagOp.Cha),1);
for c=1:length(LagOp.Cha), 
  uc=unique(LagOp.Cha{c}); 
  usi{c}=repmat(1:length(LagOp.Cha{c}),2,1);
  usi{c}(2,:)=0*usi{c}(2,:);
  for l=1:length(uc) 
    ndx=find(LagOp.Cha{c}==uc(l));
    [sLagOp.Lag{c}(ndx),usi{c}(1,ndx)]=sort(LagOp.Lag{c}(ndx));
    usi{c}(2,ndx)=uc(l);
  end;
end 


