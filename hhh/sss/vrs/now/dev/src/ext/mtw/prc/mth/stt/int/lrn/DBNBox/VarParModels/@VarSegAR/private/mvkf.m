function [init]=mvkf(X,K,options)
% compute initial values of segmented AR model based on 
% kalman filter recurions 
%
% M             max. likelihood solution for weights
% Sigma 	max. likelihood noise precisions
% iSigma        inverse of Sigma
% Phi        	max. likelihood parameter precisions
% iPhi          inverse of Phi
  
  p=options.p;
  Gamma=options.gamma;
  segsize=options.initsegsize;
  offset=options.initoffset;
  
  [T,ndim]=size(X);
  
  % getting some initial values to start the Kalman filter recursions
  segX=X(1:segsize,:);			% short segment for initvals
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
    
  % assign intial values from ml-solution
  Sigma=inv(noise_cov);		% noise precision is constant
  M=w_ml;			% initial mean of coefficients
  iSigma=noise_cov;
  iPhi=inv_xtx';
  Phi=xtx';

  % now start Kalman recursions
  x=membed(X,p,1);		% lag vector
  y=X([p+1:1:end],:);		% traget vector

  l=2;
  for t=2:offset:size(y,1),
    C_t=x(t,:)'*x(t,:)+Phi;
    M(:,:,l)=inv(C_t)*(x(t,:)'*y(t,:) + Phi*M(:,:,l-1));
    l=l+1;
  end
  %plot(squeeze(M(1,:,:))'),hold on, plot(squeeze(M(2,:,:))'),hold off,pause;
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
    init(k).Phi=Phi;
    init(k).iSigma=inv(Sigma);
  end
  