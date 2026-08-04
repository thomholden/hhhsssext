function [obsmodel] = init(obsmodel,X,varargin)
% function [obsmodel] = init(obsmodel,X,options)
%
% Initialise LIKE observation model. This actually no
% observation model as such but the observations are likelihoods already
% 
% X         N x K data matrix


K=length(obsmodel);
[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

% The only thing that must be OK is that number of likelihoods
% match the number hidden states

if ndim~=K,
  error('Data must be of size N-by-[state space dimension]');
end

