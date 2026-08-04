function [modavLL] = evalobsfreeenergy (hmm,Xtrain);
% [modavLL] = evalobsfreeenergy(hmm,X);
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
% modavLL     averaged Log-Likelihood of data under model
  
  
  modavLL=[0];

  % get messages
  Gamma=gethsbeliefs(hmm);

  % loop through obsmodels
  for k=1:length(hmm.obsmodel),
    [avLL]=evalue(hmm.obsmodel{k},Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
  end
  modavLL=sum(modavLL);
  
  % check outlier model
  if isobject(hmm.outlmodel)
    k=hmm.K;				% last is kernel
    [avLL]=evalue(hmm.outlmodel,Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
  end

  modavLL=sum(modavLL);
