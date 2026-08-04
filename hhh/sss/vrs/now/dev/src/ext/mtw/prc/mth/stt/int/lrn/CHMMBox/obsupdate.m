function [hmm] = obsupdate (X,T,Gamma,Gammasum,hmm,update)
% function [hmm] = obsupdate (X,T,Gamma,Gammasum,hmm,update)
% 
% Update observation model
% 
% X             observations
% T             length of series
% Gamma         p(state given X)
% Gammasum      Sum of Gamma over all T
% hmm           hmm data structure
% update        vector denoting which state obsmodels to update 
%               (default = [1,1,...hmm.K])

if nargin < 6 | isempty(update), update=ones(1,hmm.K); end

p=length(X(1,:));
N=length(X(:,1));
N=N/T;
K=hmm.K;


switch hmm.obsmodel
  case 'GaussCom',
    Cov=zeros(p,p,K);
    for l=1:K
      s=hmm.state(l).priors.Norm_Prec*hmm.state(l).priors.Norm_Mu';
      % temp variable
      t=2*hmm.state(l).priors.Wish_alpha+hmm.state(l).priors.Wish_k-1;  
      % temp variable
      if update(l)
	Mu_d=Gammasum(l)*eye(p)+hmm.state(l).Cov*hmm.state(l).priors.Norm_Prec;
	Mu=(inv(Mu_d)*(X'*Gamma(:,l) + hmm.state(l).Cov*s))';
	hmm.state(l).Mu=Mu;
	d=(X-ones(T*N,1)*Mu);
	Cov(:,:,l)=(rprod(d,Gamma(:,l))'*d+2*hmm.state(l).priors.Wish_B)/ ...
	    (Gammasum(l)+t);
      end
    end
    Cov=sum(Cov,3)/N;
    for l=1:K
      if update(l)
	hmm.state(l).Cov=Cov;
      end
    end
  case 'Gauss',
    for l=1:K
      s=hmm.state(l).priors.Norm_Prec*hmm.state(l).priors.Norm_Mu';  
      % temp variable
      t=2*hmm.state(l).priors.Wish_alpha-hmm.state(l).priors.Wish_k-1;  
      % temp variable
      if update(l),
	Mu_d=Gammasum(l)*eye(p)+hmm.state(l).Cov*hmm.state(l).priors.Norm_Prec;
	Mu=(inv(Mu_d)*(X'*Gamma(:,l) + hmm.state(l).Cov*s))';
	hmm.state(l).Mu=Mu;
	d=(X-ones(T*N,1)*Mu);
	hmm.state(l).Cov=rprod(d,Gamma(:,l))'*d+2*hmm.state(l).priors.Wish_B;
	hmm.state(l).Cov=hmm.state(l).Cov/(Gammasum(l)+t);
      end
    end;
  case 'LIKE',
    % The observations are themselves likelihoods
    % There is no observation model to update
  otherwise
    disp('Unknown observation model');
end
