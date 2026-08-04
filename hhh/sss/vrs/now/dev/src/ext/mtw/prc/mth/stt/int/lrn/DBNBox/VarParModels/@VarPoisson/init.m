function [obsmodel] = init(obsmodel,X,varargin)
% function [obsmodel] = init(obsmodel,X,options)
%
% Initialise Poisson observation models
% 
% X         N x p data matrix
% obsmodel  obsmodel data structure
% options   none



[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

defaultoptions=[];
if nargin<3
  options=defaultoptions;
else
   options=[];
end;

obsmodel=initpriors(obsmodel,X,options);
obsmodel=initpost(obsmodel,X,options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpriors(obsmodel,X,options)

[T,ndim]=size(X);
K=length(obsmodel);

for k=1:K,
   defstateprior(k)=struct('Gamma_alpha',[],'Gamma_beta',[]);
   defstateprior(k).Gamma_alpha=1;	% 1 count per interval
   defstateprior(k).Gamma_beta=1;	% mean HR=60BPM
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

for k=1:K,
   ndx=floor(rand(1,1)*T+1);		% randsom sample size
   ndx=floor(rand(1,ndx)*T+1);		% randomly select from train-set
   s=sum(X(ndx,1),1);
   n=sum(X(ndx,2),1);
   obsmodel(k).Gamma_alpha=n;
   obsmodel(k).Gamma_beta=s;
end
  
