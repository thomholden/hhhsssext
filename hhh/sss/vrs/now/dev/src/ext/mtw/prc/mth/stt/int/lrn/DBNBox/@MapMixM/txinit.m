function [mix] = txinit (mix,varargin)
% function [mix] = txinit (mix,K,txmodeloptions,priors)
% Initialise MM hidden state parameters
%
% mix		mix data structure
% options       
%     .comppri   flag to indicate whether priors are self intialed
%                or provided
%     .priors    pre-set priors, used if options.[tx|s0]modeloptions.comppri=1
% 
%

  defpriors=[];
  defaultoptions=struct('comppri',1,'priors',defpriors);


  if ~isfield(mix,'txmodelname')
    mix.txmodelname='MwModel';
  end

  if length(varargin)<1,
    txmodeloptions=defaultoptions;
  else
    txmodeloptions=varargin{1};
  end

  % initialise state transition model
  switch mix.txmodelname
    case 'MwModel'
     mix.txmodel=MapMwModel(mix.K,txmodeloptions);
   otherwise
    error('Error: Undefined state transition model');
  end
  
