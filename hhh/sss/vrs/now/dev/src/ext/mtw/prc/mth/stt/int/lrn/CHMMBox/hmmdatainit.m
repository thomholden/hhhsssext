function [hmm] = hmmdatainit (X,hmm,covtype)

% function [hmm] = hmmdatainit (X,hmm,covtype)
%
% Initialise Gaussian observation HMM model 
% uses the data to initialise static Gaussian Mixture Model
%
% X		N x p data matrix
% hmm		hmm data structure
% covtype	'full' or 'diag' covariance matrices

N=size(X,1);
p=size(X,2);
mix.ncentres=hmm.K;

% get some ranges within which the random values should lie
initmean=mean(X);
initvar=cov(X);

%  inititalisation; 
for k=1:mix.ncentres,
   mix.centres(k,:)=initmean;
   if covtype=='full',
      mix.covars(:,:,k)=initvar;
   elseif covtype=='diag',
      mix.covars(k,:)=diag(initvar)';
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
