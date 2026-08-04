function [avLL] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL] = evalue (obsmodel,Xtrain,Gamma);
%
% Evaluates the average log-likelihood for Gamma observation model
% 
% INPUT
%
% Xtrain       training data structure
% Gamma        probability of states conditioned on data 
% obsmodel     data structure 
%
% OUTPUT
% avLL         average log-likelihood
%


Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);
  
Gammasum=sum(Gamma);

avLL=0;
KLdiv=[];

hs=obsmodel;		% for ease of referencing
  
avLL=Gammasum.*(hs.alpha.*log(hs.beta)-gammaln(hs.alpha));
avLL=avLL+(hs.alpha-1).*(Gamma'*log(Xtrain))-hs.beta.*(Gamma'*Xtrain);
