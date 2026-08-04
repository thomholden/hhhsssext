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
  [obsmodel]=VarGauss(K,X,varargin{:});
 case 'Multinomial'
  [obsmodel]=VarMultinomial(K,X,varargin{:});
 case 'Poisson'
  [obsmodel]=VarPoisson(K,X,varargin{:});
 case {'AR'}
  [obsmodel]=VarAR(K,X,varargin{:});
 case {'FT'}
  [obsmodel]=VarFT(K,X,varargin{:});
 case {'SegAR'}
  [obsmodel]=VarSegAR(K,X,varargin{:});
 case {'Uniform'}
  [obsmodel]=VarUniform(K,X,varargin{:});
 case {'Like'}
  [obsmodel]=VarLike(K,X,varargin{:});
otherwise
   error('Error: Undefined observation model');
end


% keep obsmodel in states
mix.obsmodel=obsmodel;
