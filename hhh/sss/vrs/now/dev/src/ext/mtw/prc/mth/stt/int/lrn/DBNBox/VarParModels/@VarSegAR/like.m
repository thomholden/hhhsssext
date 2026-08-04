function [B] = like(obsmodel,Xtrain,varargin)
% function [B] = like(obsmodel,Xtrain)
%
% Evaluate likelihood of data given a Autoregressive observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points

p=obsmodel.p;			% model order
segs=obsmodel.segsize;			% segment size
offs=obsmodel.offset;			% segment offset

Tar=Xtrain.X;				% get targets
Bas=Xtrain.G;				% get  bases

sv=size(Tar);				
Te=sv(end);				% embedded length
ndim=size(Tar,1);			% data dimension

kronimpl=1;

if kronimpl			% use kronecker prod implementation
  
  x=reshape(Bas,p*ndim*segs,Te);
  y=reshape(Tar,ndim*segs,Te);
  
  hs=obsmodel;
    
  exptSig=hs.Sigma_Wish_alpha*hs.Sigma_Wish_iB;
  ldetWishB=0.5*log(det(hs.Sigma_Wish_B));
  PsiWish_alphasum=0;
  for d=1:ndim,
    PsiWish_alphasum=PsiWish_alphasum+...
	digamma(hs.Sigma_Wish_alpha+0.5-d/2);
  end;
  PsiWish_alphasum=PsiWish_alphasum*0.5;
    
  XXt=0;
  for d1=1:hs.Coeff_MvNorm_q,
    for d2=1:hs.Coeff_MvNorm_q,	% tr( X_t X_t'*iPhi) forall t
      XXt=XXt+squeeze(sum(Bas(d1,:,:).*Bas(d2,:,:),2))*...
	  hs.Coeff_MvNorm_iPhi(d2,d1);
    end
  end
  NormWishtrace=0.5*trace(exptSig*hs.Coeff_MvNorm_iSigma)*XXt;
    
  A=kron(eye(segs),hs.Coeff_MvNorm_Omega);
  C=kron(eye(segs),exptSig);
  dist=mdist(y,A*x,C);
    
  B=PsiWish_alphasum-ldetWishB+(dist-NormWishtrace)/segs;

else
  hs=obsmodel;
  
  exptSig=hs.Sigma_Wish_alpha*hs.Sigma_Wish_iB;
  OBO=hs.Coeff_MvNorm_Omega'*exptSig*hs.Coeff_MvNorm_Omega;
  OB=hs.Coeff_MvNorm_Omega'*exptSig;
    
  PsiWish_alphasum=0;
  YXtOB=0;XXtOBO=0;XXt=0;YYtB=0;
  for d1=1:hs.Coeff_MvNorm_q,
    for d2=1:hs.Coeff_MvNorm_q,	
      % tr( X_t X_t'*iPhi) forall t
      XXt=XXt+squeeze(sum(Bas(d1,:,:).*Bas(d2,:,:),2))*...
	  hs.Coeff_MvNorm_iPhi(d2,d1);
      % tr(BOXX'O') forall t
      XXtOBO=XXtOBO+squeeze(sum(Bas(d1,:,:).*Bas(d2,:,:),2))*...
	     OBO(d2,d1);
    end
    for d2=1:hs.Coeff_MvNorm_p,
      % trace(BYX'O') forall t
      YXtOB=YXtOB+squeeze(sum(Tar(d2,:,:).*Bas(d1,:,:),2))*...
	    OB(d1,d2);
      if d1<=hs.Coeff_MvNorm_p,
	% trace(BYY') forall t
	YYtB=YYtB+squeeze(sum(Tar(d1,:,:).*Tar(d2,:,:),2))*...
	     exptSig(d2,d1);
	PsiWish_alphasum=PsiWish_alphasum+...
	    digamma(hs.Sigma_Wish_alpha+0.5-d1/2);
      end			
    end				% d2 loop
  end;				% d1 loop
    
  PsiWish_alphasum=PsiWish_alphasum*0.5;
  ldetWishB=0.5*log(det(hs.Sigma_Wish_B));
  NormWishtrace=0.5*trace(exptSig*hs.Coeff_MvNorm_iSigma)*XXt;
    
  dist=-0.5*(YYtB-2*YXtOB+XXtOBO);
    
  B=PsiWish_alphasum-ldetWishB+(dist-NormWishtrace)/segs;

end

B=exp(B).^segs;



