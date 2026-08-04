function [chschain]=update(chschain,varargin);
% [chschain]=update(chschain,B)
% 
% performs  belief propagation on hidden state
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

% assume from here that chschain is node clustered and thus just 1 chain
for n=1:length(B.block),
  L = B.block(n).L;
  S=chschain.S.block{n};
  [Gamma,Xi,S]=gibbs(blkchschain,L,S);
  chschain.Gamma.block{n}=Gamma;
  chschain.Xi.block{n}=Xi;
  chschain.S.block{n}=S;
end
  
