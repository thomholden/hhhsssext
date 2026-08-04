function [Xtrain] = initXtrain (obsmodel,X,T,Nb)
% function [Xtrain] = initXtrain (obsmodel,X,T,Nb)
%
% Initialise Gaussian observation model's training data
% 
% X          N by p data matrix
% T          lengths of individual blocks
% Nb          Number of blocks (time series data can be split into many blocks)
% obsmodel   obsmodel data structure
%
% Xtrain     Data structure containing the modified data

  T=cumsum([0 T]);

  Xtrain=struct('block',[],'ndim',size(X,2),'T',size(X,1));
  for n=1:N,
    Xtrain.block(n).X=X(T(n)+1:T(n+1),:);
  end
  
