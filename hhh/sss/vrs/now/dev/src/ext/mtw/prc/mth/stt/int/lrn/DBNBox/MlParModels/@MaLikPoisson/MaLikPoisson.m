function [obsmodel]=MaLikPoisson(varargin);
% [obsmodel]=MaLikPoisson(K,X,options);
% contructor for Maximum Likelihood univariate Poisson observation models 
%
% K              State Space dimension
% X              Training data
% options        options for the observation model
% 
% 
% $$$ 
% $$$ DataMembers
% $$$   options:        options to the observation model
% $$$   lambda
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise observation model
% $$$   like()             evaluate data likelihood under model
% $$$   update()           udpate observation model parameters
% $$$   evalue()             evaluate free energy of observation model

  

ClassName='MaLikPoisson';
% default state space dimension
defK=2;

% default hmm model structure
defobsmodelstruct=struct('lambda',[],'options',[]);




switch nargin
 case 0				% no arguments
   % create temporary object
   rawobsmodel=repmat(rawobsmodel,[1,defK]);
   rawobsmodel=class(rawobsmodel,ClassName);
   for k=1:defK,
     obsmodel{k}=rawobsmodel(k);
   end
 otherwise
  if isa(varargin{1},ClassName)
    obsmodel=varargin{1};			% just return;
    return;
  else
    rawobsmodel=defobsmodelstruct;
    [K,Xtrain,options]=mydeal(varargin{:});
    
    % dimension of state space
    if isempty(K)
      K=defK;
    end

    % create temporary object
    rawobsmodel=repmat(rawobsmodel,[1,K]);
    rawobsmodel=class(rawobsmodel,ClassName);
    
    % initialise observation model if data is available
    if ~isempty(Xtrain),
      if ~isempty(options),
	rawobsmodel=init(rawobsmodel,Xtrain,options);
      else
	rawobsmodel=init(rawobsmodel,Xtrain);
      end
    end
    % distribute in cell array
    for k=1:K,
      obsmodel{k}=rawobsmodel(k);
    end
  end;
end


