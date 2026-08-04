function [obsmodel] = update (obsmodel,Xtrain,Gamma,varargin)
% function [obsmodel] = update (obsmodel,Xtrain,Gamma)
% 
% Update Poisson observation model
% 
% Xtrain        training data structure
% Gamma         p(state given X)
% obsmodel           obsmodel data structure
 
  
Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);
Gammasum=sum(Gamma);

hs=obsmodel;			% temporary structure

lambda=Gamma'*Xtrain(:,2);
lambda=lambda./(Gamma'*Xtrain(:,1));

obsmodel.lambda=lambda;




