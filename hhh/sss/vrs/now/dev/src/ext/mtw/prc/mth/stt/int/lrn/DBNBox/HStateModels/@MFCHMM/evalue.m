function [Entr] = evalue (chschain,T);
% [Entr] = evalue (chschain,T);
%
% Computes the Free Energy of the state chain part of (C)HMM
% 
% INPUT
% chschain   Chschains object with values of Gamma and Xi
% T      lengths of individual blocks
%
% OUTPUT
%  Entr       entropy of hidden states
%


Entr=zeros(1,chschain.NChains);
for c=1:chschain.NChains,
  [Gamma,Xi]=getbeliefs(chschain,c);
  Entr(c)=evalsinglechain(Gamma);
end
Entr=sum(Entr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Entr]=evalsinglechain(Gamma);
% compute entropy of one of the coupled chains
% one chain
% INPUT
% Gamma    Hidden state marginal distributions


% All States are assumed independent (mean field)
Gamma=Gamma(:);
Gamma=Gamma(find(Gamma~=0));
Entr=sum(sum(Gamma.*log(Gamma)));	% Entropy of independent states

