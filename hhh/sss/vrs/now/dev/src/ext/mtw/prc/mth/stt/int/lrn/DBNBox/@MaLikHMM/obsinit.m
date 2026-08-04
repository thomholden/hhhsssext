function [hmm] = obsinit (hmm,X,K,varargin)
% function [hmm] = obsinit (hmm,X,K,options)
%
% Initialise observation models in HMM
% 
% X         N x p data matrix
% K         number of obsmodels to intialise
% hmm       hmm data structure
% options   see
%           MaLikGauss,
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
  [obsmodel]=MaLikGauss(K,X,varargin{:});
 case 'Gamma'
  [obsmodel]=MaLikGamma(K,X,varargin{:});
  case 'AR'
  [obsmodel]=MaLikAR(K,X,varargin{:});
 case 'Poisson'
  [obsmodel]=MaLikPoisson(K,X,varargin{:});
 case 'Gamma'
  [obsmodel]=MaLikGamma(K,X,varargin{:});
 case 'Like'
  [obsmodel]=MaLikLike(K,X,varargin{:});
otherwise
   error('Error: Undefined observation model');
end


% keep obsmodel in states
hmm.obsmodel=obsmodel;
