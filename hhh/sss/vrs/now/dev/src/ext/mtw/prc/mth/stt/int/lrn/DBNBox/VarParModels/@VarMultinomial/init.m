function [obsmodel] = initMultinomial (obsmodel,X,varargin)
% function [obsmodel] = initMultinomial (obsmodel,X,options)
%
% Initialise Multinomial observation models
% 
% X         N x p data matrix
% obsmodel  obsmodel data structure
% options   
%         Bins          Number of bins for Dirichlet observation model

K=length(obsmodel);

[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

defaultoptions=struct('Bins',3,'cells',[]);

MaX=max(X,[],1);  MiX=min(X,[],1); 
gsc=(1./defaultoptions.Bins+1).^sign(MaX);
lsc=(1-1./defaultoptions.Bins).^sign(MiX);
MaX=gsc.*MaX; MiX=lsc.*MiX;
RaX=(MaX-MiX)./defaultoptions.Bins;
for d=1:ndim,
  defaultoptions.cells(d,:)=MiX(d):RaX(d):MaX(d);
end;
defaultoptions.Bins=size(defaultoptions.cells,2)-1;

if nargin<3
  options=defaultoptions;
else
  options=varargin{1};
  if ~isfield(options,'Bins')
    options.Bins=defaultoptions.Bins;
  end;
  if ~isfield(options,'cells')
    options.cells=defaultoptions.cells;
  end;
end;

obsmodel=initpriors(obsmodel,X,options);
obsmodel=initpost(obsmodel,X,options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpriors(obsmodel,X,options)

[T,ndim]=size(X);
K=length(obsmodel);

% priors
for k=1:K,
   defstateprior(k)=struct('Dir_alpha',[],'Dir_k',[]);
   defstateprior(k).Dir_alpha=ones(ndim,options.Bins);
   defstateprior(k).Dir_k=options.Bins;
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
function [obsmodel] = initpost(obsmodel,X,options)
  
  [T,ndim]=size(X);
  K=length(obsmodel);

  % Initialising the posteriors
  for k=1:K,
    N=zeros(ndim,length(options.cells));
    ndx=floor(rand(1,floor(T./K))*T+1);% randomly select from train-set
    for d=1:ndim,
      N(d,:)=histc(X(ndx,d),options.cells(d,:))';
    end
    N=N(:,1:end-1);
    N=N+ones(size(N));			% minimum count
    obsmodel(k).Dir_alpha=N;
    obsmodel(k).Dir_k=prod(size(N));
    obsmodel(k).cells=options.cells;
  end;

