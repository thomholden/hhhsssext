function [modavLL,modKLdiv] = evalobsfreeenergy (chmm,Xtrain);
% [modavLL,modKLdiv] = evalobsfreeenergy(chmm,X);
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
% modKLdiv    Model parameters KL divergences
  
  
  modavLL=[0];
  modKLdiv=[];
  
  for c=1:chmm.NChains,
    % messages first
    Gamma=gethsbeliefs(chmm,c);		% get weights
    obsmodel=getchain(chmm,c,'obsmodel');
    
    % loop through obsmodels
    for k=1:length(obsmodel),
      [avLL,KLdiv]=evalue(obsmodel{k},Xtrain(c),Gamma(:,k),k);
      if chmm.train.obsupdate(c)==1 | chmm.train.evalallfren==1
	modavLL=cat(2,modavLL,avLL);
	modKLdiv=cat(2,modKLdiv,KLdiv);
      end
    end
    
    outlmodel=getchain(chmm,c,'outlmodel');% check outlier model
    if isobject(outlmodel)		% do you have an outlier model?
      k=hmm.K;				% last is outlier kernel
      [avLL,KLdiv]=evalue(outlmodel,Xtrain(c),Gamma(:,k),k);
      if chmm.train.outlupdate==1 | chmm.train.evalallfren==1
	modavLL=cat(2,modavLL,avLL);
	modKLdiv=cat(2,modKLdiv,KLdiv);
      end
    end
    modavLL=sum(modavLL);
  end
  modavLL=sum(modavLL);
