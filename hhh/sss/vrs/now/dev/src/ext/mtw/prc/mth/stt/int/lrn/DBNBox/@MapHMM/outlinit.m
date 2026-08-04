function [hmm] = outlinit (hmm,X,varargin)
% function [hmm] = outlinit (hmm,X,options)
%
% Initialise outlier models in HMM, called by constructor
% 
% X         N x p data matrix
% hmm       hmm data structure
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
switch hmm.outlmodelname,
 case {'Uniform'}
  [outlmodel]=VarUniform(1,X,varargin{:});
otherwise
   error('Error: Undefined outlier model');
end

% keep outlmodel in field
hmm.outlmodel=outlmodel{1};




