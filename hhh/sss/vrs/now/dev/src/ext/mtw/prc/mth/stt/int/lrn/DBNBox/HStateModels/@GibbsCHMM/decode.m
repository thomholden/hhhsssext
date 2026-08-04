function [chschain]=decode(chschain,varargin);
% [chschain]=decode(chschain)
% 
% find MAP solution of hidden state
% chains using Gibbs Sampling
% 
% B     Data likelihoods
% 

[B]=deal(varargin{:});

blkchschain.NSamp=chschain.NSamp;
blkchschain.NSampBurnin=chschain.NSampBurnin;
blkchschain.LagOp=chschain.LagOp;
blkchschain.LagOpSpec=chschain.LagOpSpec;
blkchschain.NChains=chschain.NChains;
blkchschain.K=chschain.K;
blkchschain.P=chschain.P;
blkchschain.Pi=chschain.Pi;

for n=1:length(B.block),
  L = B.block(n).L;
  S=chschain.S.block{n};
  [S]=mapgibbs(blkchschain,L,S);
  chschain.decode(n).q_star=S;
end
  
