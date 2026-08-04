function [chschain]=decode(chschain,varargin);
% [chschain]=decode(chschain,B)
% 
% find MAP solution of hidden state
% chains using mean field chains
% 
% B     Data likelihoods
% 

[B]=deal(varargin{:});

blkchschain.NSweep=chschain.NSweep;
blkchschain.LagOp=chschain.LagOp;
blkchschain.LagOpSpec=chschain.LagOpSpec;
blkchschain.NChains=chschain.NChains;
blkchschain.K=chschain.K;
blkchschain.P=chschain.P;
blkchschain.Pi=chschain.Pi;

for n=1:length(B.block),
  L = B.block(n).L;
  Gamma=chschain.Gamma.block{n};
  pXi=chschain.pXi.block{n};
  [delta,psi,q_star,likv,lik_best]=mfchainvit(blkchschain,Gamma,pXi,L);
  chschain.decode(n).delta=delta;
  chschain.decode(n).q_star=q_star;
  chschain.decode(n).psi=psi;
  if n==1,
    chschain.LL=likv;
    chschain.LL_best=lik_best;
  else
    chschain.LL=chschain.LL+likv;
    chschain.LL_best=chschain.LL_best+lik_best;
  end
end
