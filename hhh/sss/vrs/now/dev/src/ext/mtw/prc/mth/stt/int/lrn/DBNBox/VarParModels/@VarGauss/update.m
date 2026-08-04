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

% Update posterior Normals
postprec=Gammasum*hs.Wish_alpha*hs.Wish_iB+hpr.Norm_Prec;
postvar=inv(postprec);
weidata=Xtrain'*Gamma(:); % unnormalised sample mean

Norm_Mu=postvar*(hs.Wish_alpha*hs.Wish_iB*weidata+ ...
		 hpr.Norm_Prec*hpr.Norm_Mu);
Norm_Prec=postprec;
Norm_Cov=postvar;

%Update posterior Wisharts
Wish_alpha=0.5*Gammasum+hpr.Wish_alpha;

dist=Xtrain-ones(T,1)*hs.Norm_Mu';
sampvar=zeros(ndim);
for n=1:ndim,
  sampvar(n,:)=sum((Gamma(:).*dist(:,n))*ones(1,ndim).*dist,1);
end;
Wish_B=0.5*(sampvar+Gammasum*hs.Norm_Cov)+hpr.Wish_B;
Wish_iB=inv(Wish_B);


obsmodel.Norm_Mu=Norm_Mu;
obsmodel.Norm_Prec=Norm_Prec;
obsmodel.Norm_Cov=Norm_Cov;
obsmodel.Wish_alpha=Wish_alpha;
obsmodel.Wish_B=Wish_B;
obsmodel.Wish_iB=Wish_iB;



