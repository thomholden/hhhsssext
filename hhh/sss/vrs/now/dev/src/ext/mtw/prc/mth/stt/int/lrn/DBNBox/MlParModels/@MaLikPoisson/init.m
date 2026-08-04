function [obsmodel] = init (obsmodel,X,options)
% function [obsmodel] = init (obsmodel,X,options)
%
% Initialise Poisson observation model in HMM
% 
% X         N x (1/2) data matrix
% obsmodel       obsmodel data structure
% options. 
%         covtype	'full' or 'diag' covariance matrices
%         gamma		weighting of each of N data points 
%         prrasc        prior range scale (scales prior variances);

K=length(obsmodel);
[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

defaultoptions=struct('covtype','full','gamma',ones(T,1));

if nargin<3
  options=defaultoptions;
else
  if ~isfield(options,'covtype'),
    options.covtype=defaultoptions.covtype;
  elseif ~ismember(options.covtype,{'full','diag'}),
    options.covtype=defaultoptions.covtype;
  end;
  if ~isfield(options,'gamma') 
    options.gamma=ones(T,1); 
  end
end;

obsmodel=initpost(X,obsmodel,options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpost(X,obsmodel,options)

[T,ndim]=size(X);
K=length(obsmodel);

% Initialising the posteriors
mix=gmm(1,K,options.covtype);
netlaboptions=foptions;
netlaboptions(14) = 5; % Just use 5 iterations of k-means initialisation
mix = gmminit(mix, X(:,2), netlaboptions);
netlaboptions = zeros(1, 18);
netlaboptions(1)  = 0;                % Prints out error values.
% Termination criteria
netlaboptions(3) = 0.000001;          % tolerance in likelihood
netlaboptions(14) = 100;              % Max. Number of iterations.
% Reset cov matrix if singular values become too small
netlaboptions(5)=1;              
[mix, netlaboptions, errlog] = wgmmem(mix, X(:,2), options.gamma, ...
   netlaboptions);

for k=1:K,
  obsmodel(k).options=options;
  obsmodel(k).lambda=mix.centres(k,:)';
end;


