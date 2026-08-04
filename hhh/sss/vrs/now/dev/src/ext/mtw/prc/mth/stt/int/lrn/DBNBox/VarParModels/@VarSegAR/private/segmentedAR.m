function [init]=segmentedAR(X,K,options)
% compute maximum likelihood solution of coefficients, noise and
% coefficients variances  for time series segments and then clusters
% coefficients for initialisation of segmented AR models
%
% M             max. likelihood solution for weights
% Sigma         max. likelihood noise precisions
% iSigma        inverse of Sigma
% Phi           max. likelihood parameter precisions
% iPhi          inverse of Phi
  
  p=options.p;
  Gamma=options.gamma;
  segsize=options.initsegsize;

  [T,ndim]=size(X);
  nSegs=floor(T/segsize);
  if nSegs<K,
     error('Insufficient data or too model order for intialsiation');
  else
     disp(sprintf('Initalised to %d Segments of size %d',nSegs,segsize));
  end
  
  for s=1:nSegs,
    segX=X((s-1)*segsize+1:s*segsize,:);
    % Embedding of multiple time series X
    % giving x=[(x1(t-1) x2(t-1) .. xd(t-1)) (x1(t-2) x2(t-2)..xd(t-2)) ...
    %           (x1(t-p) x2(t-p) .. xd(t-p))] on each row
    x=membed(segX(1:end-1,:),p,1);
    % targets
    y=segX([p+1:1:end],:);
    % Compute terms that will be used many times
    xtx=x'*x;
    inv_xtx=inv(xtx);
    
    % Get maximum likelihood solution
    w_ml = pinv(x)*y;
    y_pred = x*w_ml;
    e=y-y_pred;
    noise_cov=(e'*e)/segsize;

    
    % adapting to rest of code
    M(:,:,s)=w_ml';
    iSigma(:,:,s)=noise_cov;
    iPhi(:,:,s)=inv_xtx';

  end %loop over segments
  Gamma=mean(reshape(Gamma(1:nSegs*segsize),nSegs,segsize),2);
  [mix]=clustercoeff(M,nSegs,ndim,K,p,Gamma,'full');
  
  iPhi=squeeze(mean(iPhi,3));   % altertnative to mean of centers
  iSigma=squeeze(mean(iSigma,3));          % mean noise variance

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
