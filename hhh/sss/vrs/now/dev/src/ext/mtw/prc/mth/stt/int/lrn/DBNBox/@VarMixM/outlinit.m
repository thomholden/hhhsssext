function [mix] = outlinit (mix,X,varargin)
% function [mix] = outlinit (mix,X,options)
%
% Initialise outlier models in Mixture Model, called by constructor
% 
% X         N x p data matrix
% mix       mix data structure
% options   see
%           VarUniform,
%           etc 
%


% are any options given
if nargin<3,
  outlmodeloptions=[];
else
  outlmodeloptions=varargin{1};
end


					% initialise outlier model
switch mix.outlmodelname,
 case {'Uniform'}
  [outlmodel]=VarUniform(1,X,varargin{:});
otherwise
   error('Error: Undefined outlier model');
end

% keep outlmodel in field
mix.outlmodel=outlmodel{1};




