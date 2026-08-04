function [Y,X]=segembed(Xtrain,p,u,o);
% time delay embedding (lag 1) with addtional segment
% embedding. The Targets are thus
%Y= [ y1(t) ...  y1(t+u)]
%   [ y2(t) ...  y1(t+u)]
%and
%X= [ x1(t-1) ... x1(t+u-1) ]
%   [ x2(t-1) ... x2(t+u-1) ]
%   [ x1(t-2)               ]
%   [ x2(t-2)               ]
%   [  ..                   ]
%   [ x1(t-p)               ]
%   [ x2(t-p) ... x2(t+u-p) ]
%       
% Input 
%  Xtrain       T-by-ndim time series
%  p            embedding dimension (= AR model order)
%  u            segment size 
%  o            segment offset
% Output
%  Y            targets, array of size ndim-by-u-l
%  X            bases, array of size p*ndim-by-u-l
  
  [T,ndim]=size(Xtrain);
     
  x=membed(Xtrain(1:end-1,:),p,1)';	% basis (transp. for consistency...)
  y=Xtrain([p+1:1:T],:)';		% targets (.. with paper)
  x=cat(2,randn(size(x(:,1:p))),x);
  y=cat(2,randn(size(y(:,1:p))),y);
  
  if u==1, 
    X(:,1,:)=x;
    Y(:,1,:)=y;
    return;				% done
  else					% segmentation requestes
    Y=rmembed(y',u,o)';
    Y=reshape(Y,ndim,u,size(Y,2));

    X=rmembed(x',u,o)';
    X=reshape(X,p*ndim,u,size(X,2));
  end
  
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

  
function [U]=rmembed(X,embdim,lag);
% Embedding of multiple time series X without changing order
% giving x=[(x1(t-p) x2(t-p) .. xd(t-p)) .. (x1(t-2) x2(t-2)..xd(t-2))..
%            (x1(t-1) x2(t-1) .. xd(t-1)) ] on each row

  [T,ndim]=size(X);
  U=[];
  for i=1:embdim,
    tmpx=X(i:lag:T-embdim+i,:);
    U=[U,tmpx];
  end

  
  
  
  