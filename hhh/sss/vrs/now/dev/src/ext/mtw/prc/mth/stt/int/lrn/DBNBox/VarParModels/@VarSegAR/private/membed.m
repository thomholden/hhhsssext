function [U]=membed(X,embdim,lag);
% Embedding of multiple time series X
% giving x=[(x1(t-1) x2(t-1) .. xd(t-1)) (x1(t-2) x2(t-2)..xd(t-2)) ...
%           (x1(t-p) x2(t-p) .. xd(t-p))] on each row

  [T,ndim]=size(X);
  U=[];
  for i=1:embdim,
    tmpx=X(i:lag:T-embdim+i,:);
    U=[tmpx,U];
  end
