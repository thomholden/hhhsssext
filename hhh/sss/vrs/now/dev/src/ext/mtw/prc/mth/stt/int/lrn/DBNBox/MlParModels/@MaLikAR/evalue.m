function [avLL] = evalue(obsmodel,Xtrain,Gamma,varargin);
% [avLL] = evalue(obsmodel,Xtrain,Gamma);
%
% Computes the KL divergence and avg Log-Likelihood for Autoregressive
% observation model 
% 
% INPUT
%
% Xtrain       training data structure
% Gamma        probability of states conditioned on data 
% obsmodel     data structure 
%
% OUTPUT
% avLL    averaged log-likelihood
%

  Xtrain=cat(1,Xtrain.block(:).X);
  [T,ndim]=size(Xtrain);

  p=obsmodel.p;			% model order

  x=membed(Xtrain(1:end-1,:),p,1)';	% basis (transp. for consistency...)
  y=Xtrain([p+1:1:T],:)';		% targets (.. with paper)
  Gamma=Gamma';
  Gammasum=sum(Gamma);
  
  avLL=0;
  
  ltpi=ndim/2*log(2*pi);
  
  hs=obsmodel;		% for ease of referencing
  
  ldetC=0.5*log(det(hs.Prec));
  wdist=Gamma(p+1:1:T)*mdist(y,hs.A*x,hs.Cov);

  avLL=avLL+Gammasum.*(-ldetC-ltpi)+wdist;
  

