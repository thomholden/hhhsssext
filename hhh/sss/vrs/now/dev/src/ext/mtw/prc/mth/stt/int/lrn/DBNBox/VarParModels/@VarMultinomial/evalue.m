function [avLL,KLdiv] = evalue(obsmodel,Xtrain,Gamma,varargin);
% [avLL,KLdiv] = evalue(obsmodel,Xtrain,Gamma);
%
% Computes the KL divergence and avg Log-Likelihood for 
% Multinomial observation model
% 
% INPUT
%
% Xtrain       training data structure
% Gamma        probability of states conditioned on data 
% obsmodel     data structure 
%
% OUTPUT
% avLL    averaged log-likelihood
% KLdiv    KL divergenc array 
%

  Xtrain=cat(1,Xtrain.block(:).X);

  [T,ndim]=size(Xtrain);
  
  Gammasum=sum(Gamma);
  
  avLL=0;
  KLdiv=[];
  
  hs=obsmodel;
  hpr=obsmodel.prior;
  
  PsiDir_alphasum=digamma(sum(sum(hs.Dir_alpha)));
  Ds=sum(sum(hs.Dir_alpha));
  for d=1:ndim,
    for c=1:length(hs.cells(d,:))-1,
      ndx=(hs.cells(d,c)<=Xtrain(:,d) & Xtrain(:,d) <hs.cells(d,c+1));
      PsiDir_alpha=digamma(hs.Dir_alpha(d,c));
      avLL=avLL+sum(Gamma(ndx).*(PsiDir_alpha-PsiDir_alphasum));
    end;
  end;
  CountDiv=dirichlet_kl(hs.Dir_alpha(:),hpr.Dir_alpha(:));
  KLdiv=[KLdiv CountDiv];
  
