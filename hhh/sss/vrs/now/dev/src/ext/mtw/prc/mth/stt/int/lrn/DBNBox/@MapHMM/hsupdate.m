function [hmm]=hsupdate(hmm,Xtrain,T)
% [varargout]=hsinference(hmm,Xtrain,T) 
% 
% inference of hidden states in  HMMs
% 
% INPUT
%
% Xtrain    observation sequence
% T         lengths of individual blocks
% hmm       hmm data structure
%
% OUTPUT in case of forward-backward and gibbs sampling 
% 
% hmm       hmm data structrue
% 

  % update hidden state chain
  hmm=sethspar(hmm,'P',{get(hmm.txmodel,'P')});
  hmm=sethspar(hmm,'Pi',{get(hmm.txmodel,'Pi')});
 
  for n=1:length(T)
    % get likelihood first
    L=obslike(hmm,Xtrain,n);
    LL=num2cell(L,2);
    B.block(n).L=LL;
  end
  hmm.hschain=update(hmm.hschain,B);
  


