function [chmm] = paramupdate (chmm,Xtrain,N)
% 
% [chmm] = paramupdate (chmm,Xtrain,N)
% 
% performs M step (parameter update) on all chains of the CHMM
% 
  % update flags
  train=chmm.train;	
  
  for c=1:chmm.NChains,
    
    % transition matrices and initial state
    chmm.chain(c)=txupdate(chmm.chain(c),N,train.pupdate(c,1));
    
    % Observation models
    chmm.chain(c)=obsupdate(chmm.chain(c),Xtrain(c),train.obsupdate(c,:));

  end; 

