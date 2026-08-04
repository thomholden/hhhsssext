function [avLL,lPri] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL,lPri] = evalue (obsmodel,Xtrain,Gamma);
%
% Evaluates the average data log-likelihood and parameter log-likelihood
% for Poisson observation model 
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
  
avLL=0;
  
hs=obsmodel;		% for ease of referencing
hpr=obsmodel.prior;
  
logYfac=gammaln(Xtrain(:,2)+1);                      %  log(y_i!)
YlogX=Xtrain(:,2).*log(Xtrain(:,1));                     % y_i log x_i

avLL=avLL+sum(Gamma(:).*(-logYfac+YlogX+Xtrain(:,2).*log(hs.lambda)...
                           -Xtrain(:,1)*hs.lambda));

% Means
lpmean=gammapdf(hs.lambda,hpr.Gamma_alpha,hpr.Gamma_beta,1);

lPri=[lpmean];
