function [avLL,KLdiv] = evalue(obsmodel,Xtrain,Gamma,varargin);
% [avLL,KLdiv] = evalue(obsmodel,Xtrain,Gamma);
%
% Computes the KL divergence and avg Log-Likelihood for LIKE observation model
% 
% INPUT
%
% X            observations
% Gamma        probability of states conditioned on data 
% obsmodel     obsmodel data structure 
%
% OUTPUT
% avLL    averaged log-likelihood
% KLdiv    KL divergenc array 
%

Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);
k=varargin{1};

KLdiv=[];				% no model
avLL=sum(Gamma(:).*Xtrain(:,k));

