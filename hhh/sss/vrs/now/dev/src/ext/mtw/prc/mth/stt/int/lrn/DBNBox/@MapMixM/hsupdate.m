function [mix]=hsupdate(mix,Xtrain,T)
% [varargout]=hsinference(mix,Xtrain,T) 
% 
% inference of hidden states in  mixture models
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
    L=exp(log(L)+log(Lw));
    L=normalise(L')';
    mix.hsnodes.Gamma.block{n}=L;
end



  


