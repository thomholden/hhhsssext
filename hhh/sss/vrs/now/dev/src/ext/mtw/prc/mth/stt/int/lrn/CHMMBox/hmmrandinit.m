function [hmm] = hmmrandinit (X,hmm,covtype)

% function [hmm] = hmmrandinit (X,hmm,covtype)
%
% Initialise Gaussian observation HMM model 
% using a randomly initialised static Gaussian Mixture Model
%
% X		N x p data matrix
% hmm		hmm data structure
% covtype	'full' or 'diag' covariance matrices

N=size(X,1);
p=size(X,2);
mix.ncentres=hmm.K;

% get some ranges within which the random values should lie
initmean=mean(mean(X));
initvar=mean(var(X));

% random inititalisation; 
for k=1:mix.ncentres,
   mix.centres(k,:)=initmean*rand(1,p);
   if covtype=='full',
      mix.covars(:,:,k)=initvar*rand(p,p);
      mix.covars(:,:,k)=mix.covars(:,:,k)'*mix.covars(:,:,k);
   elseif covtype=='diag',
      mix.covars(k,:)=initvar*rand(1,p);
   else
      error('Unknown type of covariance matrix');
   end;
end;   

hmm.gmmll=0;     % Log likelihood of gmm model; not used in rand. init.

for k=1:mix.ncentres;
  hmm.state(k).Mu=mix.centres(k,:);
  switch covtype
    case 'full',
      hmm.state(k).Cov=squeeze(mix.covars(:,:,k));
      hmm.init_val(k).Cov = hmm.state(k).Cov;  % In case we need to re-init
    case 'diag',
      hmm.state(k).Cov=diag(mix.covars(k,:));
      hmm.init_val(k).Cov = hmm.state(k).Cov; % In case we need to re-init
    otherwise,      
      disp('Unknown type of covariance matrix');
  end
end

hmm.train.init='gmm';

hmm.mix=mix;
