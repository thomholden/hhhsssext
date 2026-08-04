function [avLL,KLdiv] = evalue (obsmodel,Xtrain,Gamma,varargin);
% [avLL,KLdiv] = evalue(obsmodel,XtrainGamma);
%
% Computes the KL divergence and avg Log-Likelihood for Segmented 
% Autoregressive observation model 
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

   
  p=obsmodel.p;				% model order
  segs=obsmodel.segsize;			% segment size
  offs=obsmodel.offset;			% segment offset
  ndim=Xtrain.ndim;				% data dimension

  Tar=cat(1,Xtrain.block(:).X);  
  Bas=cat(1,Xtrain.block(:).G);  
  sv=size(Tar);				
  Te=sv(end);				% embedded length
  x=reshape(Bas,p*ndim*segs,Te);
  y=reshape(Tar,ndim*segs,Te);


  KLdiv=[];
  avLL=0;

Gammasum=sum(Gamma);
ltpi=segs*ndim/2*log(2*pi);

hs=obsmodel;		% for ease of referencing
hpr=obsmodel.prior;
exptSig=hs.Sigma_Wish_alpha*hs.Sigma_Wish_iB;
   
PsiWish_alphasum=0;
for d=1:hs.Sigma_Wish_k,
  PsiWish_alphasum=PsiWish_alphasum+...
      digamma(hs.Sigma_Wish_alpha+0.5-d/2);
end;
PsiWish_alphasum=0.5*PsiWish_alphasum;
ldetWishB=0.5*log(det(hs.Sigma_Wish_B));
   
A=kron(eye(segs),hs.Coeff_MvNorm_Omega);
C=kron(eye(segs),exptSig);
wdist=sum(Gamma(:).*mdist(y,A*x,C));
   
XXt=sum(x.*(kron(eye(segs),hs.Coeff_MvNorm_iPhi)*x),1); % tr(X*X'*Phi)

NormWishtrace=0.5*hs.Sigma_Wish_alpha*...
    trace(hs.Sigma_Wish_iB*hs.Coeff_MvNorm_iSigma)*...
    (XXt*Gamma(:));
   
avLL=avLL+Gammasum.*(PsiWish_alphasum-ldetWishB-ltpi)+wdist-NormWishtrace;
   
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
   

