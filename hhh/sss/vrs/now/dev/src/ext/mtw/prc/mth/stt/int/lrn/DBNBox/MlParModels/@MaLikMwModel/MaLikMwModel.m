function [txmodel]=MaLikMwModel(varargin);
% [txmodel]=MaLikMxModel(K,txmodeloptions,priors);
% contructor for Maximum Likelihood mixture models
%
% K              State Space dimension
% 
% $$$ 
% $$$ DataMembers
% $$$   K               dimension of state space
% $$$   P               component probability
% $$$ 
% $$$ Methods
% $$$ 
% $$$   init()             initialise observation model
% $$$   like()             evaluate data likelihood under model
% $$$   update()           udpate observation model parameters
% $$$   evalue()           evaluate free energy of observation model

  

ClassName='MaLikMwModel';
% default state space dimension
defK=2;
defKv=[defK];
% default options
defaultoptions=struct([]);
% default hmm model structure
deftxmodelstruct=struct('K',defKv,'options',[],'P',ones(1,defK)./defK);



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



