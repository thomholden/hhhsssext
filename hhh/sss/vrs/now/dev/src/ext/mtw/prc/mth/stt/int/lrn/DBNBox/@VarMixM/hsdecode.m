function [mix]=hsdecode(mix,Xtrain,T)
% [varargout]=hsinference(mix,Xtrain,T) 
% 
% decoding of hidden states in  MIXs
% 
% INPUT
%
% Xtrain    observation sequence
% T         lengths of individual blocks
% mix       mix data structure
%
% OUTPUT in case of forward-backward and gibbs sampling 
% 
% mix       mix data structrue
% 

Gamma=gethspar(mix,'Gamma');
 
for n=1:length(T)
    % get likelihood first
    L=obslike(mix,Xtrain,n);
    Lw=txlike(mix,Gamma,n);
    L=L.*Lw;
    L=normalise(L')';
    [mix.hsnodes.decode.block(n).gamma,mix.hsnodes.decode.block(n).q_star]=...
        max(L,[],2);
    
end

