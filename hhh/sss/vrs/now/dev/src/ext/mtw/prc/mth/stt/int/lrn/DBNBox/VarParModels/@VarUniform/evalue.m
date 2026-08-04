function [avLL,KLdiv] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL,KLdiv] = evalue (obsmodel,Xtrain,Gamma);
%
% Computes the KL divergence and avg Log-Likelihood for Uniform
% outlier model. 
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
  if ndims(Xtrain)==2,
    [T,ndim,segs]=size(Xtrain);
  else
    [ndim,segs,T]=size(Xtrain);
  end

  KLdiv=[0];				% no model update
  avLL=sum(segs*Gamma(:).*log(obsmodel.p0));

