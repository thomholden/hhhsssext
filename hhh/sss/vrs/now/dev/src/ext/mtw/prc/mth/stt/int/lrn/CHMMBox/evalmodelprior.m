function [logprior] = evalmodelprior (hmm);
% function [logprior] = evalmodelprior (hmm);
% 
% Evaluates the prior depending on observation model
% 
% hmm data structure logprior vector of log probabilities under prior
%

K=hmm.K;

logprior=[];
switch hmm.obsmodel
 case 'GaussCom',
  for l=1:K,
    % Means
    logprior=[logprior  gaussmd(hmm.state(l).Mu,hmm.state(l).priors.Norm_Mu, ...
				hmm.state(l).priors.Norm_Cov,1)];
    % Covariances
    logprior=[logprior wishart(hmm.state(l).Cov,hmm.state(l).priors.Wish_B, ...
			       hmm.state(l).priors.Wish_alpha,1)];
  end;
 case 'Gauss',
  for l=1:K,
    % Means
    logprior=[logprior  gaussmd(hmm.state(l).Mu,hmm.state(l).priors.Norm_Mu, ...
				hmm.state(l).priors.Norm_Cov,1)];
    % Covariances
    logprior=[logprior wishart(hmm.state(l).Cov,hmm.state(l).priors.Wish_B, ...
			       hmm.state(l).priors.Wish_alpha,1)];
  end;
 case 'LIKE',
  % The observations are themselves likelihoods There is no model to evaluate
 otherwise
  disp('Unknown observation model');
end
