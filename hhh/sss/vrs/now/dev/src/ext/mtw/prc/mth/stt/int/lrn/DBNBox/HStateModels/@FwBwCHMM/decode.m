function [chschain]=decode(chschain,varargin);
% [hschain]=decode(hschain,varargin)
% 
%  Viterbi decoding for hmm chain
% 
% INPUT
%
% B     Data likelihoods
% 
 

[B]=deal(varargin{:});

for n=1:length(B.block),
  L = B.block(n).L;
  % merge the chains to produce one single chain
  [hschain,L]=nodemerge(chschain,L);
  % apply viterbi on merged chain
  [delta,psi,q_star,likv,lik_best]=viterbi(hschain,L);
  % split viterbi squence to one for each chain
  [chvit]=splitviterbi(chschain,q_star,length(L));
  chschain.decode(n).delta=delta;
  chschain.decode(n).psi=psi;
  chschain.decode(n).q_star=q_star;
  chschain.decode(n).chvit=chvit;
  if n==1,
    chschain.LL=likv;
    chschain.LL_best=lik_best;
  else
    chschain.LL=chschain.LL+likv;
    chschain.LL_best=chschain.LL_best+lik_best;
  end
end

