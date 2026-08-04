function [hmm] = obsinit (hmm,X,K,varargin)
% function [hmm] = obsinit (hmm,X,K,options)
%
% Initialise observation models in HMM
% 
% X         N x p data matrix
% K         number of obsmodels to intialise
% hmm       hmm data structure
% options   see
%           MapGauss,
%           etc 
%


if isempty(hmm.obsmodelname)
  hmm.obsmodelname='Gauss';
end

if nargin<4,
  obsmodeloptions=[];
else
obsmodeloptions=varargin{1};
end

% initialise observation model
switch hmm.obsmodelname,
 case 'Gauss'
  [obsmodel]=MapGauss(K,X,varargin{:});
 case 'Poisson'
  [obsmodel]=MapPoisson(K,X,varargin{:});
 case 'Like'
  [obsmodel]=MapLike(K,X,varargin{:});
otherwise
   error('Error: Undefined observation model');
end


% keep obsmodel in states
hmm.obsmodel=obsmodel;
