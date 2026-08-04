function [Xtrain] = initXtrain (obsmodel,X,T,Nb)
% function [Xtrain] = initXtrain (obsmodel,X,T,Nb)
%
% Initialise Segmented Autoregressive observation model's training data
% 
% X          N by p data matrix
% T      lengths of individual blocks
% Nb          Number of blocks (time series data can be split into many blocks)
% obsmodel   obsmodel data structure
%
% Xtrain     Data structure containing the modified data

  T=cumsum([0 T]);

  % assuming state one is template
  p=obsmodel.p;				% model order
  segs=obsmodel.segsize;		% segment size
  offs=obsmodel.offset;			% segment offset

  Xtrain=struct('block',[],'ndim',size(X,2),'T',size(X,1));
  for n=1:Nb,
    [tar,bas]=segembed(X(T(n)+1:T(n+1),:),p,segs,offs);
    Xtrain.block(n).X=tar;		% targets
    Xtrain.block(n).G=bas;		% bases
  end
  
  
  
