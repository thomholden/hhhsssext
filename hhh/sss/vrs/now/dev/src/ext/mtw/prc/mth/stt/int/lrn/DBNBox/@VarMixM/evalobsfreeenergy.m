function [modavLL,modKLdiv] = evalobsfreeenergy (mix,Xtrain);
% [modavLL,modKLdiv] = evalobsfreeenergy(mix,X);
%
% Computes the Free Energy of the observation model part of the mixture
% model
%
% INPUT
%
% X            observations
% mix          data structure 
%
% OUTPUT
%
% modavLL     averaged Log-Likelihood of data under model
% modKLdiv    Model parameters KL divergences
  
  
  modavLL=[0];
  modKLdiv=[];
  % get messages
  Gamma=gethsbeliefs(mix);
  
  for k=1:length(mix.obsmodel), % loop through obsmodels
    [avLL,KLdiv]=evalue(mix.obsmodel{k},Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
    modKLdiv=cat(2,modKLdiv,KLdiv);
  end
  modavLL=sum(modavLL);

  % check outlier model
  if isobject(mix.outlmodel)
    k=mix.K;				% last is kernel
    [avLL,KLdiv]=evalue(mix.outlmodel,Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
    modKLdiv=cat(2,modKLdiv,KLdiv);
  end
  modavLL=sum(modavLL);
