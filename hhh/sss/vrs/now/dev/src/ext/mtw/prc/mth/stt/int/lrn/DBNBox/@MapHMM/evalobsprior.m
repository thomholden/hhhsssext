function [modlogprior] = evalobsprior (hmm,Xtrain);
% [modlogprior] = evalobsprior(hmm,X);
%
% Computes the Free Energy of the observation model part of the HMM
% model
%
% INPUT
%
% X            observations
% hmm          data structure 
%
% OUTPUT
%
% logprior     log probabilities of parameters under their prior

  
  
  modlogprior=[];

  % get messages
  Gamma=gethspar(hmm,'Gamma{1}');
  
  % loop through obsmodels
  for k=1:length(hmm.obsmodel),
    [logprior]=evalue(hmm.obsmodel{k},Xtrain,Gamma(:,k),k);
    modlogprior=cat(2,modlogprior,logprior);
  end


  % check outlier model
  if isobject(hmm.outlmodel)
    k=hmm.K;				% last is kernel
    [logprior]=evalue(hmm.outlmodel,Xtrain,Gamma(:,k));
    modlogprior=cat(2,modlogprior,logprior);
  end
