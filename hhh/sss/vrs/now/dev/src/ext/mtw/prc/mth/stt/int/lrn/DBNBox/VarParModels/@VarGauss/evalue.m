function [avLL,KLdiv] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL,KLdiv] = evalue (obsmodel,Xtrain,Gamma);
%
% Computes the KL divergence and avg Log-Likelihood for Gaussian observation model
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
  
  ltpi=0.5*ndim*log(2*pi);
  hs=obsmodel;		% for ease of referencing
  hpr=obsmodel.prior;
  
  dist=mdist(Xtrain,hs.Norm_Mu,hs.Wish_iB*hs.Wish_alpha);
  NormWishtrace=0.5*trace(hs.Wish_alpha*hs.Wish_iB*hs.Norm_Cov);
  ldetWishB=0.5*log(det(hs.Wish_B));
  PsiWish_alphasum=0;
  for d=1:ndim,
    PsiWish_alphasum=PsiWish_alphasum+...
	digamma(hs.Wish_alpha+0.5-d/2);
  end;
  PsiWish_alphasum=0.5*PsiWish_alphasum;
  
  avLL=Gammasum.*(PsiWish_alphasum-ldetWishB-NormWishtrace-ltpi)+...
       sum(Gamma.*dist);
  
  % KL divergences of Normals and Wishart
  VarDiv=wishart_kl(hs.Wish_B,hpr.Wish_B,hs.Wish_alpha,hpr.Wish_alpha);
  MeanDiv=gauss_kl(hs.Norm_Mu,hpr.Norm_Mu,hs.Norm_Cov,hpr.Norm_Cov);
  KLdiv=[KLdiv MeanDiv VarDiv];


