function [txmodel] = init (txmodel,varargin)
% function [txmodel] = init (txmodel,options)
%
% Initialise  Chain's hidden state transition model parameters
%
% txmodel		txmodel data structure
% options               options for intialisation
%

  defaultoptions=struct([]);
  
  if nargin<2,
    options=defaultoptions;
  else
    options=varargin{1};
  end
  
% Initialising the posteriors
  K=txmodel.K;
  P=1*ones(1,K);
  P=cdiv(P,csum(P));			% make prob

