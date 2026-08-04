function [avLL] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL] = evalue (obsmodel,Xtrain,Gamma);
%
% Evaluates the average data log-likelihood for Poisson observation model 
% 
% 
% INPUT
%
% Xtrain       training data structure
% Gamma        probability of states conditioned on data 
% obsmodel     data structure 
%
% OUTPUT
% avLL         average data log-likelihood 


Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);
  
hs=obsmodel;		% for ease of referencing
  
logYfac=gammaln(Xtrain(:,2)+1);                      %  log(y_i!)
YlogX=Xtrain(:,2).*log(Xtrain(:,1));                     % y_i log x_i

avLL=sum(Gamma(:).*(-logYfac+YlogX+Xtrain(:,2).*log(hs.lambda)...
                           -Xtrain(:,1)*hs.lambda));
