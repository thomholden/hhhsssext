function [txmodel]=MaLikTxModels(varargin);
% [txmodel]=MaLikTxModels(K,txmodeloptions,priors);
% contructor for maximum likelihood state transition models 
%
% K              State Space dimension
% 
% $$$ 
% $$$ DataMembers
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

  

ClassName='MaLikTxModels';
% default state space dimension
defK=2;
defKv=[defK defK];
defaultoptions=struct([]);
% default hmm model structure
deftxmodelstruct=struct('K',defKv,'options',defaultoptions, ...
			'Pi',ones(1,defK)./defK,...
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
    [K,txmodeloptions]=mydeal(varargin{:});
    
    % dimension of state space
    if ~isempty(K)
      txmodel.K=K;
    end

    % any options
    if isempty(txmodeloptions),
      txmodeloptions=defaultoptions;
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


