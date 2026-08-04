function [txmodel] = init (txmodel,varargin)
% function [txmodel] = init (txmodel,options)
%
% Initialise  Chain's hidden state transition model parameters
%
% txmodel		txmodel data structure
% options               options for intialisation
%

  defaultoptions=struct('comppri',1);
  
  if nargin<2,
    options=defaultoptions;
  else
    options=varargin{1};
    if ~isfield(options,'comppri'),
      options.comppri=1;
    end
  end
  
% Initialising the posteriors
  K=txmodel.K;
  txmodel.Dir_alpha=1*ones(1,K);
  P=txmodel.Dir_alpha;
  P=cdiv(P,csum(P));			% make prob

  % define P-priors
  deftxmodelprior=struct('Dir_alpha',[]);
  
  deftxmodelprior.Dir_alpha=ones(1,K);

  % assigning default priors for observation models
  prfields=struct2cell(txmodel.prior);
  if all(cellfun('isempty',prfields)),
      txmodel.prior=deftxmodelprior;
  else
      % prior not specified are set to default
      txmodelpriorlist=fieldnames(deftxmodelprior);
      fldname=fieldnames(txmodel.prior);
      for i=1:length(fldname),
          if isempty(getfield(txmodel.prior,fldname{i})),
              priorval=getfield(deftxmodelprior,txmodelpriorlist{i});
              txmodel.prior=setfield(txmodel.prior,txmodelpriorlist{i}, ...
                  priorval);
          end
      end;
  end;  
