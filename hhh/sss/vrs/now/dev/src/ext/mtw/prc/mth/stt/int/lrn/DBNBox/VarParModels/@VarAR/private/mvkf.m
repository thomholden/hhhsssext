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
  