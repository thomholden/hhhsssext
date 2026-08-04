function [B] = like (obsmodel,Xtrain,varargin)
% function [B] = like (obsmodel,Xtrain)
%
% Evaluate likelihood of data given a sinusoidal observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points


  Xtrain=Xtrain.X;

  [T,ndim]=size(Xtrain);

  p=obsmodel.p;			% model order
  w=obsmodel.w;			% kernel frequency

  x=[sin(w*[0:T-1]) ;cos(w*[0:T-1])];	% spectral basis
  y=Xtrain';					% targets

  B=zeros(T,1);
  
  hs=obsmodel;
  ldetWishB=0.5*log(det(hs.Sigma_Wish_B));
  PsiWish_alphasum=0;
  for d=1:ndim,
    PsiWish_alphasum=PsiWish_alphasum+...
	digamma(hs.Sigma_Wish_alpha+0.5-d/2);
  end;
  PsiWish_alphasum=PsiWish_alphasum*0.5;
  
  NormWishtrace=0.5*trace(inv(hs.Sigma_Wish_B*hs.Coeff_MvNorm_Sigma))*...
      hs.Sigma_Wish_alpha*...
      (sum(x.*(inv(hs.Coeff_MvNorm_Phi)*x),1))';
  
  dist=mdist(y,hs.Coeff_MvNorm_Omega*x,hs.Sigma_Wish_alpha* ...
	     inv(hs.Sigma_Wish_B));
  
  B=PsiWish_alphasum-ldetWishB+dist-ndim/2* ...
    log(2*pi)-NormWishtrace;
  
  B=exp(B);


