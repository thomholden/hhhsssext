function [hmm] = cobsinit (X,hmm)

% function [hmm] = cobsinit (X,hmm)
%
% Initialise observation models in CHMM
% for hmm.obsmodel = 'GaussCom' or 'Gauss'
% 
% X         N x p data matrix
% hmm       hmm data structure

p=length(X(1,:));
for ccntr=1:hmm.Nc,
 K=hmm.K;
 switch hmm.obsmodel
  case 'GaussCom','Gauss',
    Cov=diag(diag(cov(X)));
    Mu=randn(K,p)*sqrtm(Cov)+ones(K,1)*mean(X);
    for k=1:K,
      hmm.state(k).Mu=Mu(k,:);  % Init different cov matrices to global cov
      hmm.state(k).Cov=Cov;  % Init different cov matrices to global cov
      hmm.init_val(k).Cov = Cov; % In case we need to re-initialise
    end
  otherwise
    disp('Unknown observation model');
 end
end;


