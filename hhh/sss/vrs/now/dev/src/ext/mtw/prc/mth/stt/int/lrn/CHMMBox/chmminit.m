function [chmm] = chmminit (X,Y,chmm,covtype,gamma)

% function [chmm] = chmminit (X,Y,chmm,covtype,gamma)
%
% Initialise Gaussian observation CHMM model 
% using a static Gaussian Mixture Model (using NetLab routines
% and calling hmminit )
%
% X,Y		observations
% chmm		chmm data structure
% covtype	'full' or 'diag' covariance matrices
% gamma		2 x N weighting of each of N data points of each chain 
%		(default is 1 for each data point)

N=size(X,1);
if nargin<5 | isempty(gamma), gamma=ones(N,2); end;


K=[chmm.hmmone.K chmm.hmmtwo.K];
[chmm.hmmone] = shmminit (X,K,chmm.hmmone,covtype(1,:),gamma(:,1));

K=[chmm.hmmtwo.K chmm.hmmone.K];
[chmm.hmmtwo] = shmminit (Y,K,chmm.hmmtwo,covtype(2,:),gamma(:,2));





function [hmm] = shmminit (X,K,hmm,covtype,gamma)

% function [hmm] = shmminit (X,K,hmm,covtype,gamma)
%
% Initialise Gaussian observation HMM model 
% using a static Gaussian Mixture Model (using NetLab routines)
%
% X		N x p data matrix
% K             vector of state space of own and neighbouring chain
% hmm		hmm data structure
% covtype	'full' or 'diag' covariance matrices
% gamma		weighting of each of N data points 
%		(default is 1 for each data point)
%

% this function is similar to HMMBOX routine, but requires different priors
% for transition probability

N=size(X,1);
if nargin < 5 | isempty(gamma), gamma=ones(N,1); end

p=size(X,2);
mix=gmm(p,hmm.K,covtype);

options=foptions;
options(14) = 5; % Just use 5 iterations of k-means initialisation
mix = gmminit(mix, X, options);

options = zeros(1, 18);
options(1)  = 0;                % Prints out error values.

% Termination criteria
options(3) = 0.000001;          % tolerance in likelihood
options(14) = 100;              % Max. Number of iterations.

% Reset cov matrix if singular values become too small
options(5)=1;              
[mix, options, errlog] = wgmmem(mix, X, gamma,options);
hmm.gmmll=options(8);     % Log likelihood of gmm model

for k=1:mix.ncentres;
  hmm.state(k).Mu=mix.centres(k,:);
  switch covtype
    case 'full',
      hmm.state(k).Cov=squeeze(mix.covars(:,:,k));
      hmm.init_val(k).Cov = hmm.state(k).Cov; % In case we need to re-init
    case 'diag',
      hmm.state(k).Cov=diag(mix.covars(k,:));
      hmm.init_val(k).Cov = hmm.state(k).Cov; % In case we need to re-init
    otherwise,      
      disp('Unknown type of covariance matrix');
    end
end

hmm.train.init='gmm';

hmm.mix=mix;


% Setting of default priors
range=max(X)-min(X);
S=diag(cov(X))/100;			% educated guess with scaling
defhmmpriors=struct('Dir3d_alpha',ones(K(1),K(1),K(2)),...
		    'Dir_alpha',ones(1,K(1)));
defstatepriors=struct('Norm_Mu',range,'Norm_Cov',diag(range.^2),...
		      'Norm_Prec',diag(range.^(-2)),'Wish_B',diag(S),...
		      'Wish_alpha',ceil(p/2),'Wish_k',p);


% assigning default priors for hidden states
if ~isfield(hmm,'priors'),
  hmm.priors=defhmmpriors;
else
  % priors not specified are set to default
  hmmpriorlist=fieldnames(defhmmpriors);
  fldname=fieldnames(hmm.priors);
  misfldname=find(~ismember(hmmpriorlist,fldname));
  for i=1:length(misfldname),
    priorval=getfield(defhmmpriors,hmmpriorlist{i});
    hmm.priors=setfield(hmm.priors,hmmpriorlist{i},priorval);
  end;
end;

% assigning default priors for observation models
if ~isfield(hmm.state,'priors'),
  for j=1:hmm.K,
    hmm.state(j).priors=defstatepriors;
  end;
else
  % priors not specified are set to default
  statepriorlist=fieldnames(defstatepriors)
  fldname=fieldnames(hmm.priors.state);
  misfldname=find(~ismember(statepriorlist,fldname));
  for j=1:hmm.K,
    for i=1:length(misfldname),
      priorval=getfield(defstatepriors,statepriorlist{i});
      hmm.state.priors=setfield(hmm.state,j,'priors',statepriorlist{i},priorval);
    end;
  end;
end;      
