function [avLL,KLdiv] = evalue(obsmodel,Xtrain,Gamma,varargin);
% [avLL,KLdiv] = evalue(obsmodel,Xtrain,Gamma);
%
% Computes the KL divergence and avg Log-Likelihood for sinusoidal
% observation model 
% 
% INPUT
%
% Xtrain       training data structure
% Gamma        probability of states conditioned on data 
% obsmodel     data structure 
%
% OUTPUT
% avLL    averaged log-likelihood
% KLdiv    KL divergenc array 
%

  Xtrain=cat(1,Xtrain.block(:).X);

  [T,ndim]=size(Xtrain);

  p=obsmodel.p;			% model order
  w=obsmodel.w;			% kernel frequency

  x=[sin(w*[0:T-1]); cos(w*[0:T-1])];	% spectral basis
  y=Xtrain';					% targets

  Gamma=Gamma';
  Gammasum=sum(Gamma);
  
  KLdiv=[];
  avLL=0;
  
  ltpi=ndim/2*log(2*pi);
  
  hs=obsmodel;		% for ease of referencing
  hpr=obsmodel.prior;
  
  PsiWish_alphasum=0;
  for d=1:hs.Sigma_Wish_k,
    PsiWish_alphasum=PsiWish_alphasum+...
	digamma(hs.Sigma_Wish_alpha+0.5-d/2);
  end;
  PsiWish_alphasum=0.5*PsiWish_alphasum;
  
  ldetWishB=0.5*log(det(hs.Sigma_Wish_B));
  wdist=Gamma*mdist(y,hs.Coeff_MvNorm_Omega*x,...
			     hs.Sigma_Wish_alpha*inv(hs.Sigma_Wish_B));
  NormWishtrace=0.5*hs.Sigma_Wish_alpha*...
      trace(inv(hs.Sigma_Wish_B'*hs.Coeff_MvNorm_Sigma))*...
      (Gamma*sum(x.*(inv(hs.Coeff_MvNorm_Phi)*x),1)');
  
  avLL=avLL+Gammasum.*(PsiWish_alphasum-ldetWishB-ltpi)...
       +wdist-NormWishtrace;
  
  % KL divergences of Wisharts
  SigmaDiv=wishart_kl(hs.Sigma_Wish_B,hpr.Sigma_Wish_B,...
		      hs.Sigma_Wish_alpha,hpr.Sigma_Wish_alpha);
  PhiDiv=wishart_kl(hs.Phi_Wish_B,hpr.Phi_Wish_B,...
		    hs.Phi_Wish_alpha,hpr.Phi_Wish_alpha);
  %expectations of Phi and Sigma
  exptPhi=hs.Phi_Wish_alpha*inv(hs.Phi_Wish_B);
  % KL divergences of matrix variate normal
  exptSigma=hs.Sigma_Wish_alpha*inv(hs.Sigma_Wish_B);
  
  % compute normal KL first, then correct
  CoeffDiv=mvgauss_kl(hs.Coeff_MvNorm_Omega,hpr.Coeff_MvNorm_Omega,...
		      hs.Coeff_MvNorm_Sigma,exptSigma,...
		      hs.Coeff_MvNorm_Phi,exptPhi);
  
  % correcting for log(|Precision|)
  CoeffDiv=CoeffDiv+(p*d)*log(det(exptSigma))+d*log(det(exptPhi));
  
  % re-compute the correct log(|Precision|)
  PsiSigma_alphasum=0;
  for d=1:hs.Sigma_Wish_k,
    PsiSigma_alphasum=PsiSigma_alphasum+...
	digamma(hs.Sigma_Wish_alpha+0.5-d/2);
  end;
  PsiSigma_alphasum=0.5*PsiSigma_alphasum;
  
  PsiPhi_alphasum=0;
  for d=1:hs.Phi_Wish_k,
    PsiPhi_alphasum=PsiPhi_alphasum+...
	digamma(hs.Phi_Wish_alpha+0.5-d/2);
  end;
  PsiPhi_alphasum=0.5*PsiPhi_alphasum;
  
  CoeffDiv=CoeffDiv-(p*d)*(PsiSigma_alphasum-log(det(hs.Sigma_Wish_B)))-...
	   d*(PsiPhi_alphasum-log(det(hs.Phi_Wish_B)));
  
  
  KLdiv=[KLdiv CoeffDiv SigmaDiv PhiDiv];
   


