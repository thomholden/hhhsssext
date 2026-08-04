function [block,LL,LL_best]=decode(hmm,varargin);
% function [block,LL,LL_best]=decode(hmm,X,T)
%
% Viterbi and single-state decoding for hmm
% X         N x p data matrix
% T         length of each sequence (N must evenly divide by T, default T=N)
% hmm       hmm data structure
%
% block().q_star    maximum probability state sequence 
% block().gamma     the posterior: p(q_t=i given X)
% block().delta     proby of each previous state: see eq 33a Rabiner (1989)
% block().psi       most likely pre-cursor state: see eq 33b Rabiner (1989)
% LL                log likelihood of model
% LL_best           log likelihood of best sequence



% prepare data for training, depending on observation model
[Xtrain,Nb,T] = initXtrain (hmm,varargin{:});


hmm=hsdecode(hmm,Xtrain,T);
block=gethspar(hmm,'decode');
switch hmm.train.inftype,
 case 'forwback'
  LL=gethspar(hmm,'LL');
  LL_best=gethspar(hmm,'LL_best');
 otherwise
  LL=[];
  LL_best=[];
end