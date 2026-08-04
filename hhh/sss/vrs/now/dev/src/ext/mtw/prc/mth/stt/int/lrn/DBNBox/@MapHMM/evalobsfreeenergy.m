function [modavLL,modlPri] = evalobsfreeenergy (hmm,Xtrain);
% [modavLL,modlPri] = evalobsfreeenergy(hmm,X);
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
% modlPri     Log-Likelihood of Model parameters under prior
  
  
  modavLL=[0];
  modlPri=[];
  % get messages
  Gamma=gethsbeliefs(hmm);
  
  % loop through obsmodels
  for k=1:length(hmm.obsmodel),
    [avLL,lPri]=evalue(hmm.obsmodel{k},Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
    modlPri=cat(2,modlPri,lPri);
    modavLL=sum(modavLL);
  end

  % check outlier model
  if isobject(hmm.outlmodel)
    k=hmm.K;				% last is kernel
    [avLL,lPri]=evalue(hmm.outlmodel,Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
    modlPri=cat(2,modlPri,lPri);
    modavLL=sum(modavLL);
  end
