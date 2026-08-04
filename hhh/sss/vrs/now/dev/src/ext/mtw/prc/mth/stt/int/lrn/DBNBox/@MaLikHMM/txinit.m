function [hmm] = txinit (hmm,varargin)
% function [hmm] = txinit (hmm,K,txmodeloptions,priors)
% Initialise  HMM Chain's hidden state transition parameters
%
% hmm		hmm data structure
% options       
%     .comppri   flag to indicate whether priors are self intialed
%                or provided
%     .priors    pre-set priors, used if options.[tx|s0]modeloptions.comppri=1
% 
%

  defpriors=[];
  defaultoptions=struct('comppri',1,'priors',defpriors);


  if ~isfield(hmm,'txmodelname')
    hmm.txmodelname='TxModels';
  end

  if length(varargin)<1,
    txmodeloptions=defaultoptions;
  else
    txmodeloptions=varargin{1};
  end

  % initialise state transition model
  switch hmm.txmodelname
    case 'TxModels'
     hmm.txmodel=MaLikTxModels(repmat(hmm.K,1,2),txmodeloptions);
   otherwise
    error('Error: Undefined state transition model');
  end
  
