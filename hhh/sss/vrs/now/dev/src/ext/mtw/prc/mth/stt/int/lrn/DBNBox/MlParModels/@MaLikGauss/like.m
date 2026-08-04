function [B] = like (obsmodel,Xtrain,varargin)
% function [B] = like (obsmodel,Xtrain)
%
% Evaluate likelihood of data given a Gaussian observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points

Xtrain=Xtrain.X;
[T,ndim]=size(Xtrain);

tpi=(2*pi).^(ndim/2);

B=zeros(T,1);
hs=obsmodel;

dist=mdist(Xtrain,hs.Mu,hs.Prec);

B=1./tpi*1./sqrt(det(hs.Cov))*exp(dist);

