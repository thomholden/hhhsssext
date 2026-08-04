function [avLL,KLdiv] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL,KLdiv] = evalue(obsmodel,Xtrain,Gamma);
%
% Computes the KL divergence and avg Log-Likelihood for
% Poisson observation model
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
  
  logYfac=-gammaln(Xtrain(:,2)+1);		% -log(y_i!)
  YlogX=Xtrain(:,2).*log(Xtrain(:,1));	% y_i log x_i
  
  hs=obsmodel;
  hpr=obsmodel.prior;
  
  E_lograte=digamma(hs.Gamma_alpha)-log(hs.Gamma_beta); % <log(theta)>
  E_rate=hs.Gamma_alpha./hs.Gamma_beta;
  avLL=avLL+sum(Gamma(:).*(logYfac+YlogX+Xtrain(:,2).*E_lograte-...
			   Xtrain(:,1)*E_rate));
  RateDiv=wishart_kl(hs.Gamma_beta,hpr.Gamma_beta,hs.Gamma_alpha, ...
		     hpr.Gamma_alpha);
  KLdiv=[KLdiv RateDiv];

