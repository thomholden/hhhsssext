function [mix]=clustercoeff(A,L,ndim,K,p,Gamma,covtype);
% clusters the AR coefficients, using max. likelihood EM routine,
% for initialisation of segmetented AR models

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
