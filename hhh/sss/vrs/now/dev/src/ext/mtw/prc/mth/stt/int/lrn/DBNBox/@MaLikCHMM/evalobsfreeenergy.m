function [modavLL,modlPri] = evalobsfreeenergy (chmm,Xtrain);
% [modavLL,modlPri] = evalobsfreeenergy(chmm,X);
%
% Computes the Free Energy of the observation model part of the CHMM
% model
%
% INPUT
%
% X            observations
% chmm          data structure 
%
% OUTPUT
%
% modavLL     averaged Log-Likelihood of data under model

  
  
  modavLL=[0];
  
  for c=1:chmm.NChains,
    % messages first
    Gamma=gethsbeliefs(chmm,c);		% get weights
    obsmodel=getchain(chmm,c,'obsmodel');
    
    % loop through obsmodels
    for k=1:length(obsmodel),
      [avLL]=evalue(obsmodel{k},Xtrain(c),Gamma(:,k),k);
      if chmm.train.obsupdate(c)==1,
	modavLL=cat(2,modavLL,avLL);
      end
    end
    
    outlmodel=getchain(chmm,c,'outlmodel');% check outlier model
    if isobject(outlmodel)		% do you have an outlier model?
      k=hmm.K;				% last is outlier kernel
      [avLL]=evalue(outlmodel,Xtrain(c),Gamma(:,k),k);
      if chmm.train.outlupdate==1,
	modavLL=cat(2,modavLL,avLL);
      end
    end
    modavLL=sum(modavLL);
  end
  modavLL=sum(modavLL);
