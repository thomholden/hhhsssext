function [obsmodel]=VarUniform(varargin);
% [obsmodel]=VarUniform(K,X,options);
% contructor for variational Uniform outlier observation models 
%
% K              State Space dimension
% X              Training data
% options        options for the observation model
% 
% 
% $$$ 
% $$$ DataMembers
% $$$   options:        options to the observation model
% $$$       scale       scale uniform probablity by <scale>
% $$$   p0              Posterior Uniform Probablity
% $$$   prior           prior to parameters above
% $$$      p0           Prior Uniform Probability
% $$$ 
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise observation model
% $$$   like()             evaluate data likelihood under model
% $$$   update()           udpate observation model parameters
% $$$   evalue()           evaluate free energy of observation model

  

ClassName='VarUniform';
% default state space dimension
defK=2;
% default prior structure
defpriorstruct=struct('p0',[]);
% default hmm model structure
defobsmodelstruct=struct('p0',[],'prior',defpriorstruct,'options',[]);




switch nargin
 case 0				% no arguments
  obsmodel=defobsmodelstruct;
  obsmodel=class(obsmodel,ClassName);
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


