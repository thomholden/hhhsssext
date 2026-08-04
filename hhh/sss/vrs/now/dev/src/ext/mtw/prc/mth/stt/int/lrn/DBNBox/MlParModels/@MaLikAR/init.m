function [obsmodel] = init (obsmodel,X,options)
% function [obsmodel] = init (obsmodel,X,options)
%
% Initialise autoregessive observation model
% 
% X         N x p data matrix
% obsmodel       obsmodel data structure
% options. 
%         p     model order (default 2)
%         gamma		weighting of each of N data points 
%         prrasc        prior range scale (scales prior variances);


[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;
initmeth={'segAR','mvkalman'};
defaultoptions=struct('p',4,'gamma',ones(T,1),'sign',1,'winsize',2* ...
		      10,'initmeth',initmeth{2},'incr',1);


if nargin<3
  options=defaultoptions;
else
  if ~isfield(options,'p') 
    options.p=defaultoptions.p; 
  end
  if ~isfield(options,'gamma') 
    options.gamma=defaultoptions.gamma; 
  end
  if ~isfield(options,'initmeth') 
    options.initmeth=defaultoptions.initmeth; 
  end
  if ~isfield(options,'winsize') 
    options.winsize=options.p*10;
  end
  if ~isfield(options,'incr') 
    options.incr=defaultoptions.incr;
  end
end;

obsmodel=initpars(obsmodel,X,options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpars(obsmodel,X,options)

K=length(obsmodel);
init = compinits(X,K,options);
[T,ndim]=size(X);

% define posteriors
for k=1:K,
  obsmodel(k).options=options;
  obsmodel(k).p=options.p;
  obsmodel(k).A=init(k).M;
  obsmodel(k).Prec=init(k).Sigma;
  obsmodel(k).Cov=init(k).iSigma;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [init]=compinits(X,K,options);
% compute the initialisation values - calles different methods
  
  switch options.initmeth
    case 'mvkalman'
     init = mvkf(X,K,options);
   case 'segAR'
    init = segmentedAR(X,K,options);
   otherwise
    error('Unknown initialisation type option');
  end
  
%  init = univardAR(X,K,p,gamma);
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mix]=clustercoeff(A,L,ndim,K,p,Gamma,covtype);
% clusters the AR coefficients using max. likelihood EM routine

  A=reshape(A,p*ndim^2,L)';		% samples-by-dimensions
  mix=gmm(p*ndim^2,K,covtype);
  options=foptions;
  options(1)=0;
  options(14) = 5; % Just use 5 iterations of k-means initialisation
  mix = gmminit(mix,A, options);
  
  options = zeros(1, 18);
  
  % Termination criteria
  options(3) = 0.0001;          % tolerance in likelihood
  options(14) = 30;              % Max. Number of iterations.
  
  % Reset cov matrix if singular values become too small
  options(5)=1;              
  disp('done gmminit');
  [mix, options, errlog] = wgmmem(mix,A,Gamma,options);
  
  switch mix.covar_type
   case 'full',
    avgcov=mean(mix.covars,3);	% mean (over K) AR covariances
    if ndim~=1
      sv=[ndim,ndim,[ndim ndim]*p];
      avgcov=reshape(avgcov,sv);	% need to reduce size
      avgcov=mdsum(avgcov,[1 2]);		% integrate ok??
    end
   case 'diag';
    avgcov=mean(mix.covars,1);	% mean (over K) AR covariances
    if ndim~=1,
      sv=[ndim,ndim*p];
      avgcov=reshape(avgcov,sv);	% need to reduce size
      avgcov=sum(avgcov,1);		% integrate ok??
    end
    avgcov=diag(avgcov);		% reshape to matrix
   case 'spherical'
    avgcov=mean(mix.covars);	% mean (over K) AR covariances
    avgcov=avgcov*eye(p*ndim);	% reshape to matrix
  end
  mix.avgcov=avgcov;
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [init]=mvkf(X,K,options)
% compute initial values based on kalman filter recurions 
%
% M             max. likelihood solution for weights
% Sigma 	max. likelihood noise precisions
% iSigma        inverse of Sigma
% Phi        	max. likelihood parameter precisions
% iPhi          inverse of Phi
  
  
  p=options.p;
  Gamma=options.gamma;
  winsize=options.winsize;
  offset=options.incr;
  
  [T,ndim]=size(X);
  
  % getting some initial values to start the Kalman filter recursions
  segX=X(1:winsize,:);			% short segment for initvals
  
  x=membed(segX(1:end-1,:),p,1);		% lag vector
  y=segX([p+1:1:end],:);			% targets
  k=p*ndim*ndim;				% coeff-vector size
  
  % Compute terms
  xtx=x'*x;
  
  % Get maximum likelihood solution
  w_ml = pinv(x)*y;
  e=y-(x*w_ml);
  noise_cov=(e'*e)/winsize;
  
  % assign intial values from ml-solution
  Sigma=inv(noise_cov);		% noise precision is constant
  M=w_ml;			% initial mean of coefficients
  Phi=xtx';			% coefficient precision is const.
  x=membed(X,p,1);		% lag vector
  y=X([p+1:1:end],:);		% traget vector

  l=2;
  for t=2:offset:size(y,1),
    X_t=x(t,:)'*x(t,:);
    C_t=X_t+Phi;
    M(:,:,l)=inv(C_t)*(x(t,:)'*y(t,:) + Phi*M(:,:,l-1));
    l=l+1;
  end

  L=size(M,3);
  Gamma=Gamma([1 2:offset:size(y,1)]);
  [mix]=clustercoeff(M,L,ndim,K,p,Gamma,'full');
  
  %assing max.Likelihood EM solution to initialisation structure
  init=struct('M',zeros(ndim,p*ndim),'Sigma',eye(ndim),'iSigma', ...
	      eye(ndim),'Phi',eye(p*ndim),'iPhi',eye(p*ndim));


  
  for k=1:K,
    init(k).M=reshape(mix.centres(k,:),p*ndim,ndim)';
    init(k).iPhi=inv(Phi);  % was mix.avgcov;
    init(k).Sigma=Sigma;
    init(k).Phi=inv(init(k).iPhi);
    init(k).iSigma=inv(init(k).Sigma);
  end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [init]=segmentedAR(X,K,options)
% compute maximum likelihood solution of coefficients, noise and
% coefficients variances  for time series segments and then clusters
% coefficients 
%
% M             max. likelihood solution for weights
% Sigma         max. likelihood noise precisions
% iSigma        inverse of Sigma
% Phi           max. likelihood parameter precisions
% iPhi          inverse of Phi
  
  p=options.p;
  Gamma=options.gamma;
  winsize=options.winsize;
  
  [T,ndim]=size(X);
  nSegs=floor(T/winsize);
  if nSegs<K,
     error('Insufficient data or too model order for intialsiation');
  else
     disp(sprintf('Initalised to %d Segments of size %d',nSegs,winsize));
  end
  
  for s=1:nSegs,
    segX=X((s-1)*winsize+1:s*winsize,:);
    
    % Embedding of multiple time series X
    % giving x=[(x1(t-1) x2(t-1) .. xd(t-1)) (x1(t-2) x2(t-2)..xd(t-2)) ...
    %           (x1(t-p) x2(t-p) .. xd(t-p))] on each row
    x=membed(segX(1:end-1,:),p,1);
    
    % targets
    y=segX([p+1:1:end],:);
    k=p*ndim*ndim;
    
    % Compute terms that will be used many times
    xtx=x'*x;
    yty=y'*y;
    inv_xtx=inv(xtx);
    xty=x'*y;
    vec_xty=xty(:);
    
    % Get maximum likelihood solution
    w_ml = pinv(x)*y;
    y_pred = x*w_ml;
    e=y-y_pred;
    %noise_cov=(e'*e)/(T-k);
    noise_cov=(e'*e)/winsize;
    %sigma_ml=kron(noise_cov,inv_xtx);
    
    % adapting to rest of code
    M(:,:,s)=w_ml';
    Sigma(:,:,s)=inv(noise_cov); 
    iSigma(:,:,s)=noise_cov;
    
    % ??????
    xtx=xtx/winsize;
    inv_xtx=inv(xtx);
    
    Phi(:,:,s)=xtx';                  
    iPhi(:,:,s)=inv_xtx';

  end %loop over segments
  Gamma=mean(reshape(Gamma(1:nSegs*winsize),nSegs,winsize),2);
  [mix]=clustercoeff(M,nSegs,ndim,K,p,Gamma,'full');
 
  iPhi=squeeze(mean(iPhi,3));   % altertnative to mean of centers
  iSigma=squeeze(mean(iSigma,3));          % mean noise variance
%  mix.avgcov=inv_xtx';
  
  %assing max.Likelihood EM solution to initialisation structure
  init=struct('M',zeros(ndim,p*ndim),'Sigma',eye(ndim),'iSigma', ...
              eye(ndim),'Phi',eye(p*ndim),'iPhi',eye(p*ndim));
  
  for k=1:K,
    init(k).M=reshape(mix.centres(k,:),ndim,p*ndim);
    init(k).iPhi=iPhi;
    init(k).iSigma=iSigma;
    init(k).Phi=inv(init(k).iPhi);
    init(k).Sigma=inv(init(k).iSigma);
  end
