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
% modlPri     Log-Likelihood of Model parameters under prior
  
  
  modavLL=[0];
  modlPri=[];
  
  for c=1:chmm.NChains,
    % messages first
    Gamma=gethsbeliefs(chmm,c);		% get weights
    obsmodel=getchain(chmm,c,'obsmodel');
    
    % loop through obsmodels
    for k=1:length(obsmodel),
      [avLL,lPri]=evalue(obsmodel{k},Xtrain(c),Gamma(:,k),k);
      if chmm.train.obsupdate(c)==1,
	modavLL=cat(2,modavLL,avLL);
	modlPri=cat(2,modlPri,lPri);
      end
    end
    
    outlmodel=getchain(chmm,c,'outlmodel');% check outlier model
    if isobject(outlmodel)		% do you have an outlier model?
      k=hmm.K;				% last is outlier kernel
      [avLL,lPri]=evalue(outlmodel,Xtrain(c),Gamma(:,k),k);
      if chmm.train.outlupdate==1,
	modavLL=cat(2,modavLL,avLL);
	modlPri=cat(2,modlPri,lPri);
      end
    end
    modavLL=sum(modavLL);
  end
  modavLL=sum(modavLL);
