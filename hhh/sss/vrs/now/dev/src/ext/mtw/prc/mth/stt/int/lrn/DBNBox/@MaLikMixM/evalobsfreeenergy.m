function [modavLL] = evalobsfreeenergy (mix,Xtrain);
% [modavLL] = evalobsfreeenergy(mix,X);
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
  
  
  modavLL=[0];

  % get messages
  Gamma=gethsbeliefs(mix);
  
  for k=1:length(mix.obsmodel), % loop through obsmodels
    [avLL]=evalue(mix.obsmodel{k},Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
  end
  modavLL=sum(modavLL);

  % check outlier model
  if isobject(mix.outlmodel)
    k=mix.K;				% last is kernel
    [avLL]=evalue(mix.outlmodel,Xtrain,Gamma(:,k),k);
    modavLL=cat(2,modavLL,avLL);
  end
  modavLL=sum(modavLL);
