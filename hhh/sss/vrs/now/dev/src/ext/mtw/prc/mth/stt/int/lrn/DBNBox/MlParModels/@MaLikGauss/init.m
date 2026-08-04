function [obsmodel] = init (obsmodel,X,options)
% function [obsmodel] = init (obsmodel,X,options)
%
% Initialise Gaussian observation model in HMM
% 
% X         N x p data matrix
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

obsmodel=initpars(X,obsmodel,options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpars(X,obsmodel,options)

[T,ndim]=size(X);
K=length(obsmodel);

% Initialising the posteriors
mix=gmm(ndim,K,options.covtype);
netlaboptions=foptions;
netlaboptions(14) = 5; % Just use 5 iterations of k-means initialisation
mix = gmminit(mix, X, netlaboptions);
netlaboptions = zeros(1, 18);
netlaboptions(1)  = 0;                % Prints out error values.
% Termination criteria
netlaboptions(3) = 0.000001;          % tolerance in likelihood
netlaboptions(14) = 100;              % Max. Number of iterations.
% Reset cov matrix if singular values become too small
netlaboptions(5)=1;              
[mix, netlaboptions, errlog] = wgmmem(mix, X, options.gamma, ...
   netlaboptions);

[mix]=sortkernels(mix);

Sigmatmp=cov(X);

for k=1:K,
  obsmodel(k).options=options;
  obsmodel(k).Mu=mix.centres(k,:)';
  switch options.covtype
   case 'full'
     obsmodel(k).Cov=squeeze(mix.covars(:,:,k));
   case 'diag'
     obsmodel(k).Cov=diag(mix.covars(k,:));
    otherwise,      
     error('Unknown type of covariance matrix');
   end
   obsmodel(k).Prec=inv(obsmodel(k).Cov);
   obsmodel(k).init_val.Mu=obsmodel(k).Mu;
   obsmodel(k).init_val.Cov=obsmodel(k).Cov;   
   obsmodel(k).init_val.Prec=obsmodel(k).Prec;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mix]=sortkernels(mix)
% sort kernels such that the their increase in distance from the most negative kernel 
%

centres=mix.centres;
K=mix.ncentres;

% find most negative center
[d,I]=min(sqrt(sum(centres(1:end,:).^2,2)).*sum(sign(centres),2));
% permutation index
pndx=I;
% sort according to distance from centres(I,:)
[dist,I]=sort(sqrt(sum((repmat(centres(I,:),K,1)-centres(1:end,:)).^2,2)));
% permutation index
pndx=cat(1,pndx,I(2:end));
% re-assign mixtures
mix.centres=mix.centres(pndx,:);
mix.priors=mix.priors(pndx);
switch mix.covar_type
 case 'full'
  mix.covars=mix.covars(:,:,pndx);
 case 'diag'
  mix.covars=mix.covars(pndx,:);
 otherwise,      
  error('Unknown type of covariance matrix');
end
  