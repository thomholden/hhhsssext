function [B] = txlike (mix,Gamma,n)
% function [B] = txlike (mix,n)
%
% Evaluate likelihood of hiden state beliefs given component weight model
% 
% Xtrain     Training data structure
% n          block index (time series data can be split into many blocks)
% mix        mix  data structure
%
% B          Likelihood of N data points



B=like(mix.txmodel,Gamma.block{n});
