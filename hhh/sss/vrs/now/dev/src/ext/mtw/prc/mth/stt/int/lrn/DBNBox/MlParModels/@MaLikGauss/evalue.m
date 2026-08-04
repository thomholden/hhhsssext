function [avLL] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL] = evalue (obsmodel,Xtrain,Gamma);
%
% Evaluates the average log-likelihood for Gaussian observation model
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

avLL=0;
KLdiv=[];
  
ltpi=-ndim/2*log(2*pi);
hs=obsmodel;		% for ease of referencing
  
dist=mdist(Xtrain,hs.Mu,hs.Cov);
ldetC=-0.5*log(det(hs.Cov));

avLL=sum(Gamma.*(ldetC+ltpi+dist));

