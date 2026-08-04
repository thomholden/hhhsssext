function [B] = like (obsmodel,Xtrain,varargin)
% function [B] = like (obsmodel,Xtrain)
%
% Evaluate likelihood of data given a  Uniform outlier model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points


 Xtrain=Xtrain.X;
 
 if ndims(Xtrain)==2,
   [T,ndim,segs]=size(Xtrain);
 else
   [ndim,segs,T]=size(Xtrain);
 end

 % The observations are themselves likelihoods
 B=(obsmodel.p0.^segs)*ones(T,1);

