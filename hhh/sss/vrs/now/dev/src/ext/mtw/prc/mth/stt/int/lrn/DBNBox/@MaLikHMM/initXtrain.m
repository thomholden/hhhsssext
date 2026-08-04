function [Xtrain,Nb,T] = initXtrain (hmm,X,T)
% function [Xtrain,Nb,T] = initXtrain(hmm,X,T)
%
% Initialise observation model's training data
% 
% X -  N by p data matrix
% T -  length of series to learn
% N -  Number of blocks (time series data can be split into many blocks)
% hmm -  hmm data structure
% 
% Xtrain - Data structure containing the modified data
% Nb -  Number of blocks (time series data can be split into many blocks)
% T    Length of each block

[Ns,ndim]=size(X);
if length(X)~=Ns,
  X=X';
  [Ns,ndim]=size(X);
end;

if nargin<3,
  T=Ns;
  Nb=1;
else
  % Initialise stuff
  if (rem(Ns,T)~=0)
    error('Error: Data matrix length must be multiple of sequence length T');
  end;
  Nb=Ns/T;
  T=repmat(T,1,Nb);			% T for each block
end

found=0;				% found flag
for k=1:length(hmm.obsmodel),		% find matching obs model
  obsclass=class(hmm.obsmodel{k});
  obsmodelname=strcat('MaLik',hmm.obsmodelname);
  if ispc, obsmodelname=lower(obsmodelname); end;
  if ~found & strcmp(obsmodelname,obsclass), % 1st to match name
    [Xtrain]=initXtrain(hmm.obsmodel{k},X,T,Nb); % use for init
    found=1;				% don't init again
  end
end
if ~found
  error(['Could not find matching observation model for Data' ...
	 ' initialisation']);
end

