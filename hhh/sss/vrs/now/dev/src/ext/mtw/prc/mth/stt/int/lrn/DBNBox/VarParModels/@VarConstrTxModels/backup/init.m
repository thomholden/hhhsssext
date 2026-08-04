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
  txmodel.Dir_alpha=zeros(txmodel.K);
  txmodel.P=zeros(txmodel.K);
  
for k=1:txmodel.K,
  % Initial state
  txmodel.Dir1d_alpha(k)=1;
  txmodel.Pi(k)=txmodel.Dir1d_alpha(k)./txmodel.K;
  % State transitions
  txmodel.Dir_alpha(k,:)=ones(1,txmodel.K);
  txmodel.Dir_alpha(k,k)=2; 
  txmodel.P(k,:)=txmodel.Dir_alpha(k,:)./sum(txmodel.Dir_alpha(k,:),2);
end;


% define P-priors
deftxmodelprior=struct('Dir_alpha',[],'Dir1d_alpha',[]);
  
deftxmodelprior.Dir1d_alpha=ones(1,txmodel.K);
deftxmodelprior.Dir_alpha=ones(txmodel.K,txmodel.K);

% assigning default priors for hidden states
if ~isfield(txmodel,'prior') | options.comppri,
  txmodel.prior=deftxmodelprior;
else
    % priors not specified are set to default
    txmodelpriorlist=fieldnames(deftxmodelprior);
    fldname=fieldnames(txmodel.prior);
    misfldname=find(~ismember(txmodelpriorlist,fldname));
    for i=1:length(misfldname),
      priorval=getfield(deftxmodelprior,txmodelpriorlist{i});
      txmodel.prior=setfield(txmodel.prior,txmodelpriorlist{i},priorval);
    end;
end;


