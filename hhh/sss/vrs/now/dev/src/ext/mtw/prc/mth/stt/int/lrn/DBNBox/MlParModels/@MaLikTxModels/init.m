function [txmodel] = init (txmodel,varargin)
% function [txmodel] = init (txmodel,options)
%
% Initialise  Chain's hidden state transition model parameters
%
% txmodel		txmodel data structure
% options               options for intialisation
%

  
% Initialising the posteriors
  K=txmodel.K;
  Dir_alpha=1*ones(K);
  if all(K(1)==K),	% diagonal emphasis iff dims are equal
    ndx=repmat(num2cell(1:K(1),2),1,length(K)); % index for sub2ind
    ndx=sub2ind(K,ndx{:});		% linear index
    Dir_alpha(ndx)= Dir_alpha(ndx)+3;
  end
  P=Dir_alpha;
  P=reshape(P,[K(1) prod(K(2:end))]);% -> 2-D for divsion
  P=cdiv(P,csum(P));			% make transition prob
  txmodel.P=reshape(P,K);	% reshape to normal

  txmodel.Pi=ones([1 K(1)])./K(1);

