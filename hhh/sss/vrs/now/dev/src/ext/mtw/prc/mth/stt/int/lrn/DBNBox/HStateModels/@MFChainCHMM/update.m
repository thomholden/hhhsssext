function [chschain]=update(chschain,varargin);
% [chschain]=update(chschain,B)
% 
% performs  belief propagation on hidden state
% chains using simple mean field updates
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



% assume from here that chschain is node clustered and thus just 1 chain
for n=1:length(B.block),
  L = B.block(n).L;
  Gamma=chschain.Gamma.block{n};
  Xi=chschain.Xi.block{n};
  pXi=chschain.pXi.block{n};
  [Gamma,Xi,pXi]=mfchainprop(blkchschain,Gamma,Xi,pXi,L);
  chschain.Gamma.block{n}=Gamma;
  chschain.Xi.block{n}=Xi;
  chschain.pXi.block{n}=pXi;
end



