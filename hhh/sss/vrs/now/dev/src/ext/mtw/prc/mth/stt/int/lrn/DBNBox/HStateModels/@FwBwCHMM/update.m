function [chschain]=update(chschain,varargin);
% [chschain]=update(chschain,B)
% 
% performs forward-backward belief propagation on coupled hidden markov state
% chains
% 
% INPUT
% 
% B     Data likelihoods
% 

[B]=deal(varargin{:});

for n=1:length(B.block),
  L = B.block(n).L;
  % original length of state chain
  chschain.T=length(L);			
  % merge the chains to produce one single chain
  [hschain,L]=nodemerge(chschain,L);
  % apply forward/backward on merged chain
  [gamma,xi,scale]=fwbw(hschain,L);
  chschain.cartXi=xi;
  chschain.cartGamma=gamma;
  % now split the marginals for each chain
  [Gamma,Xi]=splitnodes(chschain,gamma,xi);
  % assign to block
  chschain.Gamma.block{n}=Gamma;
  chschain.Xi.block{n}=Xi;
  Scale.block{n}=log(scale);
end

chschain.Scale=sum(cat(1,Scale.block{:}));

