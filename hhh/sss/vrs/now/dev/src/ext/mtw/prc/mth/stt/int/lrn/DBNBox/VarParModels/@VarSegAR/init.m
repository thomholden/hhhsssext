function [obsmodel] = init(obsmodel,X,options)
% function [obsmodl] = init(obsmodel,X,options)
%
% Initialise segmented autoregessive observation model
% 
% X         N x p data matrix
% obsmodel  obsmodel data structure
% options. 
%         p     model order (default 2)
%         gamma		weighting of each of N data points 
%         prrasc        prior range scale (scales prior variances);


[T,ndim]=size(X);
if length(X)~=T,
  X=X';
  [T,ndim]=size(X);
end;

methlist={'mvkalman','segAR'};
defaultoptions=struct('p',2,'gamma',ones(T,1),'sign',1,'segsize',2* ...
		      10,'initmeth',methlist{1},'offset',1,'initsegsize',2*10,...
		      'initoffset',2*10);


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
  if ~isfield(options,'segsize') 
    options.segsize=options.p*10;
  end
  if ~isfield(options,'offset') 
    options.offset=defaultoptions.segsize;
  end
  if ~isfield(options,'initsegsize') 
    options.initsegsize=options.p*10;
  end
  if ~isfield(options,'initoffset') 
    options.initoffset=defaultoptions.initsegsize;
  end
end;


obsmodel=initpriors(obsmodel,X,options);
obsmodel=initpost(obsmodel,X,options);

return;

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
  obsmodel(k).segsize=options.segsize;
  obsmodel(k).offset=options.offset;
  % MV-Normal Mean

  obsmodel(k).Coeff_MvNorm_p=ndim;
  obsmodel(k).Coeff_MvNorm_q=ndim*options.p;
  obsmodel(k).Coeff_MvNorm_Omega=init(k).M;

  obsmodel(k).Coeff_MvNorm_Sigma=init(k).Sigma;
  obsmodel(k).Coeff_MvNorm_iSigma=init(k).iSigma;

  obsmodel(k).Coeff_MvNorm_Phi=init(k).Phi;
  obsmodel(k).Coeff_MvNorm_iPhi=init(k).iPhi;
  % Wishart of Sigma
  obsmodel(k).Sigma_Wish_k=ndim;

  obsmodel(k).Sigma_Wish_alpha=0.5*(obsmodel(k).Sigma_Wish_k-1)+2;
  obsmodel(k).Sigma_Wish_B=init(k).iSigma*obsmodel(k).Sigma_Wish_alpha;
  obsmodel(k).Sigma_Wish_iB=inv(obsmodel(k).Sigma_Wish_B);
  
  % Wishart of Phi
  obsmodel(k).Phi_Wish_k=ndim*options.p;
  obsmodel(k).Phi_Wish_alpha=0.5*(obsmodel(k).Phi_Wish_k-1)+.1;
  
  obsmodel(k).Phi_Wish_B=init(k).iPhi*obsmodel(k).Sigma_Wish_alpha;
  obsmodel(k).Phi_Wish_iB=inv(obsmodel(k).Phi_Wish_B);

end;

% $$$ for k=1:K,
% $$$   for d=1:ndim
% $$$     [p(:,d),f] = ar_spec(obsmodel(k).Coeff_MvNorm_Omega(d,:));
% $$$   end
% $$$   subplot(K,1,k),plot(f,p); 
% $$$   title(sprintf('Intialisation Spectrum of Model %d',k));
% $$$ end;
% $$$ drawnow,pause(2); close;

  

  

