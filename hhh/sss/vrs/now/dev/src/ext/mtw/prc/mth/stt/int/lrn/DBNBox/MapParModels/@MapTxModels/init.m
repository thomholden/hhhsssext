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
  txmodel.Dir_alpha=1*ones(K);
  if all(K(1)==K),	% diagonal emphasis iff dims are equal
    ndx=repmat(num2cell(1:K(1),2),1,length(K)); % index for sub2ind
    ndx=sub2ind(K,ndx{:});		% linear index
    txmodel.Dir_alpha(ndx)= txmodel.Dir_alpha(ndx)+3;
  end
  P=txmodel.Dir_alpha;
  P=reshape(P,[K(1) prod(K(2:end))]);% -> 2-D for divsion
  P=cdiv(P,csum(P));			% make transition prob
  txmodel.P=reshape(P,K);	% reshape to normal

  txmodel.Dir1d_alpha=ones([1 K(1)]);
  txmodel.Pi=ones([1 K(1)])./K(1);

% define P-priors
deftxmodelprior=struct('Dir_alpha',[],'Dir1d_alpha',[]);
  
deftxmodelprior.Dir1d_alpha=ones(1,K(1));
deftxmodelprior.Dir_alpha=ones(K);

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
