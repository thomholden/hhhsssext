function [block,LL,LL_best]=decode(mix,varargin);
% function [block,LL,LL_best]=decode(mix,X,T)
%
% single-state decoding for mixture models
% X         N x p data matrix
% T         length of each sequence (N must evenly divide by T, default T=N)
% mix       mix data structure
%
% block().q_star    maximum probability state sequence 
% block().gamma     the posterior: p(q_t=i given X)



% prepare data for training, depending on observation model
[Xtrain,Nb,T] = initXtrain (mix,varargin{:});


mix=hsdecode(mix,Xtrain,T);
block=mix.hsnodes.decode.block;
