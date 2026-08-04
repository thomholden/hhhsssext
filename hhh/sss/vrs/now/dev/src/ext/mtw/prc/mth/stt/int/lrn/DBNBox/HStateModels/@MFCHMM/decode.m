function [chschain]=decode(chschain,varargin);
% [chschain]=decode(chschain,B)
% 
% find MAP solution of hidden state
% chains using map mean field
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
  [S]=mfmap(blkchschain,Gamma,L);
  chschain.decode(n).q_star=S;
end
  
