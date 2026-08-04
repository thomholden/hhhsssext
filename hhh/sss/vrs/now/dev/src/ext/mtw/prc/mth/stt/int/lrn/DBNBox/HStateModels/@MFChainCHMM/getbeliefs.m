function [Gamma,Xi,pXi]=getbeliefs(chschain,varargin);
% [Gamma,Xi]=getbeliefs(chschain,chainno)
% 
% returns posterior beliefs of hidden state chains
% 
% chainno     chain number for which beliefs are requested
% 

% if chain number is provide, use this, otherwise compute all
if isempty(varargin)
  chains=1:chschain.NChains;
else
  chains=varargin{1};
end


% returning data in standard form
% first merge all blocks
cGamma=cat(1,chschain.Gamma.block{:});
cXi=cat(1,chschain.Xi.block{:});
cpXi=cat(1,chschain.pXi.block{:});
for c=1:length(chains),
  cch=chains(c);			% current chain index
  % get all parents and of those all non-native parents. these will be integrated out
  parents=chschain.LagOp.*[1 cch];
  intdim=2+find(parents(2,:)~=cch);  % 1st is time, 2nd is state itself, increment others
  % first clique-wise marginals
  nd=ndims(chschain.P{cch});
  tempXi=cat(1+ndims(cXi{1,cch}),cXi{:,cch});% merge all time steps
  Xi{c}=permute(tempXi,[nd+1 1:nd]);	% make T first dimension
  % now concatinate all pairwise marginals
  nd=2;					% it's a pairwise marginal, so 2D
  tempXi=cat(1+ndims(cpXi{1,cch}),cpXi{:,cch});% merge all time steps
  pXi{c}=permute(tempXi,[nd+1 1:nd]);	% make T first dimension
  %$$$  now integrate out from clique all non-native elements
  %$$$ pXi{c}=mdsum(Xi{c},intdim);   % this should be the pairwise joint
  % now Gamma
  tempGamma=cat(2,cGamma{:,cch});		% merge all time steps
  Gamma{c}=permute(tempGamma,[2 1]);% make T first dimension
end


if length(chains)==1,
  Gamma=Gamma{c};
  Xi=Xi{c};
  pXi=pXi{c};
end

