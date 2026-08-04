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
hpr=obsmodel.prior;		% temporary structure

% temp variable
s=hpr.Norm_Prec*hpr.Norm_Mu;  
% temp variable
t=2*hpr.Wish_alpha-hpr.Wish_k-1;  


Mu_d=Gammasum*eye(ndim)+hs.Cov*hpr.Norm_Prec;
Mu=(inv(Mu_d)*(Xtrain'*Gamma + hs.Cov*s));

d=(Xtrain-ones(T,1)*Mu');
Cov=rprod(d,Gamma(:))'*d+2*hpr.Wish_B;
Cov=Cov/(Gammasum+t);
     


obsmodel.Mu=Mu;
obsmodel.Prec=inv(Cov);
obsmodel.Cov=Cov;




