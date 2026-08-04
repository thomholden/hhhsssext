function [B] = like (obsmodel,Xtrain,varargin)
% function [B] = like (obsmodel,Xtrain)
%
% Evaluate likelihood of data given a Poisson observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points

Xtrain=Xtrain.X;
[T,ndim]=size(Xtrain);

B=zeros(T,1);
hs=obsmodel;

B=-Xtrain(:,1).*hs.lambda-gammaln(Xtrain(:,2)+1)+...
   Xtrain(:,2).*log(hs.lambda)+Xtrain(:,2).*log(Xtrain(:,1));
B=exp(B);

