function [mix]=inithsbeliefs(mix,Xtrain,T)
% [varargout]=initbeliefs(mix,Xtrain,T) 
% 
% initialise state space variables in Mixture models
% 
% INPUT
%
% Xtrain    observation sequence
% T         lengths of individual blocks
% mix      mix data structure
%
% OUTPUT 
% 
% mix      mix data structrue
% 

for n=1:length(T)
  % get likelihood 
  L=obslike(mix,Xtrain,n);
  L=normalise(L')';
  mix.hsnodes.Gamma.block{n}=L;
end


 
