function [B] = like (obsmodel,Xtrain,varargin)
% function [B] = like (obsmodel,Xtrain)
%
% Evaluate likelihood of data given a Gaussian observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points

Xtrain=Xtrain.X;
[T,ndim]=size(Xtrain);

ltpi=ndim/2*log(2*pi);

B=zeros(T,1);
hs=obsmodel;
ldetWishB=0.5*log(det(hs.Wish_B));
PsiWish_alphasum=0;
for d=1:ndim,
  PsiWish_alphasum=PsiWish_alphasum+...
      digamma(hs.Wish_alpha+0.5-d/2);
end;
PsiWish_alphasum=PsiWish_alphasum*0.5;
NormWishtrace=0.5*trace(hs.Wish_alpha*hs.Wish_iB*hs.Norm_Cov);
dist=mdist(Xtrain,hs.Norm_Mu,hs.Wish_iB*hs.Wish_alpha);

B=PsiWish_alphasum-ldetWishB+dist-ltpi-NormWishtrace;

B=exp(B);
