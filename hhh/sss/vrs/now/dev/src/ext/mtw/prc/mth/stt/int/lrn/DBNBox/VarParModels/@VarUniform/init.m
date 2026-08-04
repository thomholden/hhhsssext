function [obsmodel] = init (obsmodel,X,options)
% function [obsmodel] = init (obsmodel,X,options)
%
% Initialise Uniform outlier observation model in HMM
% 
% X         N x p data matrix
% obsmodel       obsmodel data structure
%% options   
%         scale    scale uniform probablity by <scale>


K=length(obsmodel);
[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

defaultoptions=struct('scale',1);
if nargin<3
  options=defaultoptions;
else
  if ~isfield(options,'scale')
    options.scale=defaultoptions.scale;
  end;
end;

obsmodel=initpriors(X,obsmodel,options);
obsmodel=initpost(X,obsmodel,options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpriors(X,obsmodel,options)


[T,ndim]=size(X);
K=length(obsmodel);

% priors
for k=1:K,
   defstateprior(k)=struct('p0',[]);
   defstateprior(k).p0=options.scale*prod(1./range(X));
end;

% assigning default priors for observation models
for k=1:K,
  prfields=struct2cell(obsmodel(k).prior);
  if all(cellfun('isempty',prfields)),
      obsmodel(k).prior=defstateprior(k);
  else
      % prior not specified are set to default
      statepriorlist=fieldnames(defstateprior(k));
      fldname=fieldnames(obsmodel(k).prior);
      for i=1:length(fldname),
          if isempty(getfield(obsmodel(k).prior,fldname{i})),
              priorval=getfield(defstateprior(k),statepriorlist{i});
              obsmodel(k).prior=setfield(obsmodel(k).prior,statepriorlist{i}, ...
                  priorval);
          end
      end;
  end;  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpost(X,obsmodel,options)
  
  [T,ndim]=size(X);
  K=length(obsmodel);
  % Initialising the posteriors
  for k=1:K,
    obsmodel(k).p0=options.scale*prod(1./range(X));
  end;

