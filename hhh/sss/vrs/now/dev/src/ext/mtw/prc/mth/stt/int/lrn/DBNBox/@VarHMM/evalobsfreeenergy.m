function [modavLL,modKLdiv] = evalobsfreeenergy (hmm,Xtrain);
% [modavLL,modKLdiv] = evalobsfreeenergy(hmm,X);
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
% modKLdiv    Model parameters KL divergences
  
  
  modavLL=[0];
  modKLdiv=[];
  % get messages
  Gamma=gethsbeliefs(hmm);
  
  % loop through obsmodels
  for k=1:length(hmm.obsmodel),
    [avLL,KLdiv]=evalue(hmm.obsmodel{k},Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
    modKLdiv=cat(2,modKLdiv,KLdiv);
  end
  modavLL=sum(modavLL);

  % check outlier model
  if isobject(hmm.outlmodel)
    k=hmm.K;				% last is kernel
    [avLL,KLdiv]=evalue(hmm.outlmodel,Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
    modKLdiv=cat(2,modKLdiv,KLdiv);
  end
  modavLL=sum(modavLL);
