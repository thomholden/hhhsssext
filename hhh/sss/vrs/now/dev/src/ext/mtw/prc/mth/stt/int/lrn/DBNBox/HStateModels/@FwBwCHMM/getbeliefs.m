function [Gamma,Xi]=getbeliefs(chschain,varargin);
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
cXi=cat(1,chschain.Xi.block{:});
cGamma=cat(1,chschain.Gamma.block{:});
for c=1:length(chains),
  cch=chains(c);
  nd=ndims(chschain.P{cch});
  tempXi=cat(1+ndims(cXi{1,cch}),cXi{:,cch});% merge all time steps
  Xi{c}=permute(tempXi,[nd+1 1:nd]);	% make T first dimension
  % now Gamma
  tempGamma=cat(2,cGamma{:,cch});		% merge all time steps
  Gamma{c}=permute(tempGamma,[2 1]);% make T first dimension
end

if length(chains)==1,
  Gamma=Gamma{c};
  Xi=Xi{c};
end
