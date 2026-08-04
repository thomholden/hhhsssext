function [obsmodel] = update (obsmodel,Xtrain,Gamma,varargin)
% function [obsmodel] = update (obsmodel,Xtrain,Gamma)
% 
% Update Gaussian observation model
% 
% Xtrain        training data structure
% Gamma         p(state given X)
% obsmodel           obsmodel data structure
 
  
Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);
Gammasum=sum(Gamma);

hs=obsmodel;			% temporary structure


Mu_d=Gammasum*eye(ndim);
Mu=inv(Mu_d)*(Xtrain'*Gamma);

d=(Xtrain-ones(T,1)*Mu');
Cov=rprod(d,Gamma(:))'*d;
Cov=Cov/(Gammasum);
     
if hs.options.covtype=='diag'
  Cov=eye(length(Mu)).*Cov;
end

% Check covariances (same check as NetLab GMMEM)
if min(svd(Cov)) < eps
  Cov = hs.init_val.Cov;
  warning('Covariance Matrix close to singularity. Re-initialising');
end
 


obsmodel.Mu=Mu;
obsmodel.Prec=inv(Cov);
obsmodel.Cov=Cov;




