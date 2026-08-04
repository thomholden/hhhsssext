function [txmodel]=VarConstrTxModels(varargin);
% [txmodel]=VarConstrTxModels(K,txmodeloptions,priors);
% contructor for variational state transition models 
%
% K              State Space dimension
% txmodeloptions state transition model parameter options
%     .comppri   flag to indicate whether priors are self intialed
%                or provided
%     . priors         preset priors, used if txmodeloptions.comppri=1
% 
% $$$ 
% $$$ DataMembers
% $$$   txmodeloptions   options to the state transition model
% $$$   prior           state transition model parameter priors
% $$$   K               dimension of state space
% $$$   Dir2d_alpha     state transition model parameter posteriors
% $$$   Dir_alpha       initial state parameter posterior
% $$$   P               state transition probability
% $$$   Pi              initial state probability
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise  model
% $$$   update()           udpate  model parameters
% $$$   evalue()           evaluate free energy of model

  

ClassName='VarConstrTxModels';
% default state space dimension
defK=2;
defKv=[defK defK];
% default options
defaultoptions=struct('comppri',1,'jntmod',1);
% define default P-priors
defhmmprior=struct('Dir1d_alpha',[],'Dir_alpha',[]);
% default hmm model structure
deftxmodelstruct=struct('K',defKv,'permvec',[1:length(defKv)],...
			'options',defaultoptions,'prior',defhmmprior, ...
			'Dir_alpha',ones(defK,defK)+eye(defK),...
			'Dir1d_alpha',ones(1,defK),'Pi',ones(1,defK)./defK,...
			'P',ones(defK,defK)./defK);



switch nargin
 case 0				% no arguments
  txmodel=deftxmodelstruct;
  txmodel=class(txmodel,ClassName);
 otherwise
  if isa(varargin{1},ClassName)
    txmodel=varargin{1};			% just return;
    return;
  else
    txmodel=deftxmodelstruct;
    [K,selfndx,txmodeloptions]=mydeal(varargin{:});
    
    % dimension of state space
    if ~isempty(K)
      txmodel.K=K;
    end
    
    % index pointing to (t-1) state variable of same chain
    if ~isempty(selfndx)
      selfndx=selfndx+1;
      txmodel.permvec=[1 selfndx setdiff(2:length(txmodel.K), ...
					 selfndx)];
    else
      warning('Undefined index to past state variable');
    end

    % any options
    if isempty(txmodeloptions),
      txmodeloptions=defaultoptions;
    end
    
    % provided priors
    if isfield(txmodeloptions,'priors')
      if ~isempty(txmodeloptions.priors)
	txmodel.priors=txmodeloptions.priors;
      end
    end

    % create object
    txmodel = class(txmodel,ClassName);
    
    % initialise state  model
    if ~isempty(txmodeloptions),
      txmodel=init(txmodel,txmodeloptions);
    else
      txmodel=init(txmodel);
    end
    
  end;
end


