function [obsmodel]=VarMultinomial(varargin);
% [obsmodel]=VarMultinomial(K,X,options);
% contructor for variational Discrete/Multinomial observation models 
%
% K              State Space dimension
% X              Training data
% options        options for the observation model
% 
% 
% $$$ 
% $$$ DataMembers
% $$$   Dir_alpha     posterior counts
% $$$   Dir_k         dimensionality of posterior Dirichlet
% $$$   cells         bin centeres
% $$$   prior           prior to parameters above
% $$$     Dir_alpha     prior counts
% $$$     Dir_k         dimensionality of prior Dirichlet
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise observation model
% $$$   like()             evaluate data likelihood under model
% $$$   update()           udpate observation model parameters
% $$$   evalue()             evaluate free energy of observation model

  

ClassName='VarMultinomial';
% default state space dimension
defK=2;
% default prior structure
defpriorstruct=struct('Dir_alpha',[],'Dir_k',[]);
% default hmm model structure
defobsmodelstruct=struct('cells',[],'Dir_alpha',[],...
    'Dir_k',[],'prior',defpriorstruct,'options',[]);


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


