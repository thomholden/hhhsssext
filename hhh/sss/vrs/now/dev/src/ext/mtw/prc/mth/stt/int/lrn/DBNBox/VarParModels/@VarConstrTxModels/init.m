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
  K=txmodel.K(txmodel.permvec);
  if length(K)>2,
    rK=[K(1) K(2) prod(K(3:end))];
  else
    rK=[K(1) K(2) 1];
  end

  Dir_alpha=ones(2,prod(rK(3:end)));
  for p=1:rK(3)
    PSum=sum(Dir_alpha(:,p));
    tmpP=eye(rK(1))*rK(1)*Dir_alpha(1,p);
    tmpP=tmpP+(1-eye(rK(1)))*Dir_alpha(2,p);
    if options.jntmod
      P(:,:,p)=tmpP./sum(tmpP(:));
    else
      P(:,:,p)=cdiv(tmpP,csum(tmpP));
    end
  end  
  txmodel.Dir_alpha=Dir_alpha; 
  txmodel.Dir1d_alpha=ones(1,K(1));
  txmodel.P=ipermute(reshape(P,K),txmodel.permvec);
  txmodel.Pi=ones(1,K(1))./K(1);


  % define P-priors
  deftxmodelprior=struct('Dir_alpha',[],'Dir1d_alpha',[]);  
  deftxmodelprior.Dir1d_alpha=ones(1,K(1));
  deftxmodelprior.Dir_alpha=1*ones(size(txmodel.Dir_alpha));


  
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
