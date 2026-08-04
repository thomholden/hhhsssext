function [Entr] = evalhsfreeenergy (mix);
% [Entr] = evalhsfreeenergy(mix);
%
% Computes the Free Energy of the state part of mixture model
%
% INPUT
%
% mix           data structure 
%
% OUTPUT
%
% Entr       entropy of hidden states

Gamma=gethsbeliefs(mix);
  
% All States are assumed independent (mean field)
Gamma=Gamma(:);

Gamma=Gamma(find(Gamma~=0));
Entr=sum(sum(Gamma.*log(Gamma)));	% Entropy of independent states

