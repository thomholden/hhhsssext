function [obsmodel] = init (obsmodel,X,options)
% function [obsmodel] = init (obsmodel,X,options)
%
% Initialise Linear spectral observation model

% 
% X         N x p data matrix
% obsmodel  obsmodel data structure
% options. 
%         p     model order (default 2)
%         gamma		weighting of each of N data points 
%         prrasc        prior range scale (scales prior variances);

K=length(obsmodel);
[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

defaultoptions=struct('p',2,'winsize',2*100,'fsamp',1);


if nargin<3
  options=defaultoptions;
else
  options.p=defaultoptions.p; 
  if ~isfield(options,'winsize') 
    options.winsize=defaultoptions.winsize;
  end
  if ~isfield(options,'fsamp') 
    options.fsamp=defaultoptions.fsamp;
  end
  if ~isfield(options,'w'),
    error('Missing frequency values');
  elseif length(options.w)~=K
    error('Frequency vector length mismatch');
  end
end;

obsmodel=initpriors(obsmodel,X,options);
obsmodel=initpost(obsmodel,X,options);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpriors(obsmodel,X,options)
%
% Definitions
%   Coeff_MvNorm_Omega       Coefficients' MV-Normal Prior Mean Matrix
%   Coeff_MvNorm_p           Coefficients' MV-Normal Prior dimension p
%                            (=data dimensionality)
%   Coeff_MvNorm_q           Coefficients' MV-Normal Prior dimension q
%                            (=data dimensionality x model order)
%   Sigma_Wish_alpha         Coeff. Precisions Sigma's Prior (Wish)
%                             parameter alpha
%   Sigma_Wish_B             Coeff. Precisions Sigma's Prior (Wish)
%                             scale parameter B
%   Sigma_Wish_k             Coeff. Precisions Sigma's Prior (Wish) d.o.f. 
%                             (MV-Norm dimension p)
%   Phi_Wish_alpha           Coeff. Precisions Phi's Prior (Wish)
%                             parameter alpha 
%   Phi_Wish_B               Coeff. Precisions Phi's Prior (Wish)
%                             scale parameter B
%   Phi_Wish_k               Coeff. Precisions Phi's Prior (Wish) d.o.f. 
%                             (MV-Norm dimension q)
%   
%


  [T,ndim]=size(X);
  K=length(obsmodel);

  % define priors
  for k=1:K,
    defstateprior(k)=struct('Coeff_MvNorm_Omega',[],'Coeff_MvNorm_p',[],...
			    'Coeff_MvNorm_q',[],'Sigma_Wish_alpha',[],...
			    'Sigma_Wish_B',[],'Sigma_Wish_k',[],...
			    'Phi_Wish_alpha',[],'Phi_Wish_B',[],...
			    'Phi_Wish_k',[]);
    % MV-Normal Mean
    defstateprior(k).Coeff_MvNorm_p=ndim;
    defstateprior(k).Coeff_MvNorm_q=ndim*options.p;
    defstateprior(k).Coeff_MvNorm_Omega= ...
	zeros(defstateprior(k).Coeff_MvNorm_p,defstateprior(k).Coeff_MvNorm_q);
    % Wishart of Sigma
    defstateprior(k).Sigma_Wish_k=ndim;
    defstateprior(k).Sigma_Wish_alpha=0.5* ...
	(defstateprior(k).Sigma_Wish_k-1)+0.1;
    defstateprior(k).Sigma_Wish_B= ...% more precise than Phi
	eye(defstateprior(k).Sigma_Wish_k);
    % Wishart of Phi
    defstateprior(k).Phi_Wish_k=ndim*options.p;
    defstateprior(k).Phi_Wish_alpha=0.5*(defstateprior(k).Phi_Wish_k-1)+0.1;
    defstateprior(k).Phi_Wish_B=...% less precise than Sigma
	eye(defstateprior(k).Phi_Wish_k)*10;
  end;

% assigning default priors for observation models
for k=1:K,
  prfields=struct2cell(obsmodel(k).prior);
  if all(cellfun('isempty',prfields)),
      obsmodel(k).prior=defstateprior(k);
  else
      % prior not specified are set to default
      statepriorlist=fieldnames(defstateprior(k));
      fldname=fieldnames(obsmodel(k).prior);
      for i=1:length(fldname),
          if isempty(getfield(obsmodel(k).prior,fldname{i})),
              priorval=getfield(defstateprior(k),statepriorlist{i});
              obsmodel(k).prior=setfield(obsmodel(k).prior,statepriorlist{i}, ...
                  priorval);
          end
      end;
  end;  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [obsmodel] = initpost(obsmodel,X,options)

K=length(obsmodel);
init = compinits(X,K,options);

[T,ndim]=size(X);

% define posteriors
for k=1:K,
  obsmodel(k).p=options.p;
  obsmodel(k).w=init(k).w;
  % MV-Normal Mean
  obsmodel(k).Coeff_MvNorm_p=ndim;
  obsmodel(k).Coeff_MvNorm_q=ndim*options.p;
  obsmodel(k).Coeff_MvNorm_Omega=init(k).M;
  %init(k).Sigma=inv(obsmodel(k).prior.Sigma_Wish_alpha*...
%		    inv(obsmodel(k).prior.Sigma_Wish_B));
  obsmodel(k).Coeff_MvNorm_Sigma=init(k).Sigma;
 % init(k).Phi=inv(obsmodel(k).prior.Phi_Wish_alpha*...
 %     inv(obsmodel(k).prior.Phi_Wish_B));;
  obsmodel(k).Coeff_MvNorm_Phi=init(k).Phi;
  % Wishart of Sigma
  obsmodel(k).Sigma_Wish_k=ndim;
  %obsmodel(k).Sigma_Wish_alpha=0.5*(init(k).alpha+obsmodel(k).Sigma_Wish_k);
  obsmodel(k).Sigma_Wish_alpha=0.5*(obsmodel(k).Sigma_Wish_k-1)+.1;
  
  obsmodel(k).Sigma_Wish_B=inv(init(k).Sigma)*obsmodel(k).Sigma_Wish_alpha;
%  obsmodel(k).Sigma_Wish_B=obsmodel(k).prior.Sigma_Wish_B;

  % Wishart of Phi
  obsmodel(k).Phi_Wish_k=ndim*options.p;
  obsmodel(k).Phi_Wish_alpha=0.5*(obsmodel(k).Phi_Wish_k-1)+.1;
  
  obsmodel(k).Phi_Wish_B=inv(init(k).Phi)*obsmodel(k).Phi_Wish_alpha;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [init]=compinits(X,K,options);
% compute the initialisation values - calles different methods
  
  init = FT(X,K,options);
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [mix]=clustercoeff(F,K,covtype);
% clusters the Frequencies using max. likelihood EM routine

  mix=gmm(1,K,covtype);
  options=foptions;
  options(1)=0;
  options(14) = 5; % Just use 5 iterations of k-means initialisation
  mix = gmminit(mix,F, options);
  
  options = zeros(1, 18);
  
  % Termination criteria
  options(3) = 0.0001;          % tolerance in likelihood
  options(14) = 30;              % Max. Number of iterations.
  
  % Reset cov matrix if singular values become too small
  options(5)=1;              
  disp('done gmminit');
  [mix, options, errlog] = gmmem(mix,F,options);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [init]=FT(X,K,options)
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
  fsamp=options.fsamp;
  winsize=options.winsize;
  NFFT=floor(winsize/2);
  
  [T,ndim]=size(X);
  nSegs=floor(T/winsize);
  if nSegs<K,
     error('Insufficient data or too model order for intialsiation');
  else
     disp(sprintf('Initalised to %d Segments of size %d',nSegs,winsize));
  end
  
  
  for k=1:K,
    init(k)=struct('M',ones(ndim,p*ndim),'Sigma',eye(ndim),'iSigma', ...
              eye(ndim),'Phi',eye(p*ndim),'iPhi',eye(p*ndim),...
		   'w',options.w(k));
  end
