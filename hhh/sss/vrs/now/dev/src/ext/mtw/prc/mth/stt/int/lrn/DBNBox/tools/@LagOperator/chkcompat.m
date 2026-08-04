function [flag]=chkcompat(LagOp,LagOpSpec);
%  flag=chkcompat(LagOp); 
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

flag=0;
sLagOp=LagOp;
% check for indentical number of chains
if length(LagOp.Cha)~=length(LagOpSpec),
  return;
end;
% now check whether all chains have identical number of lag entries
for c=1:length(LagOp.Cha),
  if length(LagOp.Cha{c})~=size(LagOpSpec{c},2)
    flag=0;
    return;
  end
  for ci=unique(LagOp.Cha{c})
    cond1=sum(LagOp.Cha{c}==ci);
    cond2=sum((LagOpSpec{c}(2,:)-c)==ci);
    if cond1==cond2,
      flag=1;
    else
      flag=0;
    end
  end;
end 

