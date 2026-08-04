function [mix] = obsinit (mix,X,K,varargin)
% function [mix] = obsinit (mix,X,K,options)
%
% Initialise observation models in MIX
% 
% X         N x p data matrix
% K         number of obsmodels to intialise
% mix       mix data structure
% options   see
%           VarGauss,
%           etc 
%


if isempty(mix.obsmodelname)
  mix.obsmodelname='Gauss';
end

if nargin<4,
  obsmodeloptions=[];
else
obsmodeloptions=varargin{1};
end

% initialise observation model
switch mix.obsmodelname,
 case 'Gauss'
  [obsmodel]=MapGauss(K,X,varargin{:});
 case 'Poisson'
  [obsmodel]=MapPoisson(K,X,varargin{:});
 case {'Like'}
  [obsmodel]=MapLike(K,X,varargin{:});
otherwise
   error('Error: Undefined observation model');
end


% keep obsmodel in states
mix.obsmodel=obsmodel;
