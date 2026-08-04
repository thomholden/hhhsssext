function [txmodel]=MapMwModel(varargin);
% [txmodel]=MapTxModel(K,txmodeloptions,priors);
% contructor for Maximum aposteriori mixture models
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
% $$$   Dir_alpha       component weight parameter posterior
% $$$   P               component probability
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise observation model
% $$$   like()             evaluate data likelihood under model
% $$$   update()           udpate observation model parameters
% $$$   evalue()           evaluate free energy of observation model

  

ClassName='MapMwModel';
% default state space dimension
defK=2;
defKv=[defK];
% default options
defaultoptions=struct('comppri',1);
% define default P-priors
defhmmprior=struct('Dir_alpha',[]);
% default hmm model structure
deftxmodelstruct=struct('K',defKv,'options',[],'prior',defhmmprior, ...
			'Dir_alpha',ones(1,defK),'P',ones(1,defK)./defK);



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
    [K,txmodeloptions]=mydeal(varargin{:});
    
    % dimension of state space
    if ~isempty(K)
      txmodel.K=K;
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



