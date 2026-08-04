function [B] = like(obsmodel,Xtrain,varargin)
% function [B] = like(obsmodel,Xtrain,k)
%
% Evaluate likelihood of data given a LIKE-lihood observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points


  k=varargin{1};
  [T,ndim]=size(Xtrain.X);

  % The observations are themselves likelihoods
  B=Xtrain.X(:,k);
