function [B] = like (obsmodel,Xtrain,varargin)
% function [B] = like (obsmodel,Xtrain)
%
% Evaluate likelihood of data given a Gamma observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points

Xtrain=Xtrain.X;
[T,ndim]=size(Xtrain);


B=zeros(T,1);
hs=obsmodel;

B=hs.alpha.*log(hs.beta)-gammaln(hs.alpha)+...
  (hs.alpha-1).*log(Xtrain)-hs.beta.*Xtrain;

B=exp(B);

