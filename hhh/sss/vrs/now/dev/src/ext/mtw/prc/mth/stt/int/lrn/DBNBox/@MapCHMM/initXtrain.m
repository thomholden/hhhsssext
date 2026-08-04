function [Xtrain,Nb,T] = initXtrain (chmm,X,T)
% function [Xtrain,Nb,T] = initXtrain(chmm,X,T)
%
% Initialise observation model's training data
% 
% X -  N by p data matrix
% T -  length of series to learn
% chmm - chmm data structure
% 
% Xtrain - Data structure containing the modified data
% Nb -  Number of blocks (time series data can be split into many blocks)
% T    Length of each block



% training data
if length(X)~=chmm.NChains
  error(sprintf('Need %d sets of training data',chmm.NChains));
end

% convert X into length-by-dim
for c=1:chmm.NChains,
  [Ns(c),ndim]=size(X{c});
  if length(X{c})~=Ns(c),
    X{c}=X{c}';
  end;
end

if length(unique(Ns))~=1
  error('All chains must have equal length');
else
  Ns=Ns(1);				% representative for all
end

% if not T given, i.e. use full data length
if nargin<3,
  T=Ns(1);				% T is full length
  Nb=1;					% one block
else					% check all are multiple of T
  if length(T)==1			% wants same T for all
    if rem(Ns,T)~=0
      error(['Data matrix length must be multiple of sequence' ...
	     ' length T']);
    end
    Nb=Ns./T;				% number of blocks
    T=repmat(T,1,Nb);			% T for each block
  else
    if sum(T)~=Ns
      error(['Sum of block lengths must match sequence length']);
    else
      Nb=length(T);
    end;
  end
end
  
for c=1:chmm.NChains,
  obsmodel=getchain(chmm,c,'obsmodel');
  obsmodelname=getchain(chmm,c,'obsmodelname');
  obsmodelname=strcat('Map',obsmodelname);
  if ispc, obsmodelname=lower(obsmodelname); end;
  found=0;				% found flag
  for k=1:length(obsmodel),		% find matching obs model
    obsclass=class(obsmodel{k});
    if ~found & strcmp(obsmodelname,obsclass), % 1st to match name
      Xtrain(c)=initXtrain(obsmodel{k},X{c},T,Nb); % use for init
      found=1;				% don't init again
    end
  end
  if ~found
    error(sprintf(['No matching observation model found for ' ...
		   'initXtrain of chain %d'],c));
  end
end

 
