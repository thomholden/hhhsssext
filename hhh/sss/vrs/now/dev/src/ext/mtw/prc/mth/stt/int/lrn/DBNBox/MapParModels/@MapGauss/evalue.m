function [avLL,lPri] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL,lPri] = evalue (obsmodel,Xtrain,Gamma);
%
% Evaluates the average data log-likelihood and parameter log-likelihood
% for Gaussian observation model 
% 
% 
% INPUT
%
% Xtrain       training data structure
% Gamma        probability of states conditioned on data 
% obsmodel     data structure 
%
% OUTPUT
% lPri         log-likelihood of parameters under their prior
% avLL         average data log-likelihood 


Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);
  
Gammasum=sum(Gamma);

avLL=0;
KLdiv=[];
  
ltpi=ndim/2*log(2*pi);
hs=obsmodel;		% for ease of referencing
hpr=obsmodel.prior;
  
dist=mdist(Xtrain,hs.Mu,hs.Cov);
ldetC=0.5*log(det(hs.Cov));

avLL=Gammasum.*(-ldetC-ltpi)+sum(Gamma.*dist);

% Means
lpmean=gaussmd(hs.Mu,hpr.Norm_Mu,hpr.Norm_Cov,1);

% Covariances
lpcov=wishart(hs.Cov,hpr.Wish_B,hpr.Wish_alpha,1);

lPri=[lpmean,lpcov];
