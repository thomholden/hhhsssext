function [obsmodel] = update(obsmodel,Xtrain,Gamma,varargin)
% function [obsmodel] = update(obsmodel,Xtrain,Gamma)
% 
% Update Autoregressive observation model
% 
% Xtrain        training data structure
% Gamma         p(state given X)
% obsmodel      obsmodel data structure
% X             observations


  Tar=cat(1,Xtrain.block(:).X);  
  Bas=cat(1,Xtrain.block(:).G);  
  
  p=obsmodel.p;				% model order
  segs=obsmodel.segsize;			% segment size
  offs=obsmodel.offset;			% segment offset
  Gamma=Gamma';
  Gammasum=sum(Gamma);
  hs=obsmodel;			% temporary structure
  hpr=obsmodel.prior;		% temporary structure

% $$$ some stuff first
  Gammaxx=zeros(hs.Coeff_MvNorm_q);
  Gammayx=zeros(hs.Coeff_MvNorm_p,hs.Coeff_MvNorm_q);
  Gammayy=zeros(hs.Coeff_MvNorm_p);
  for d1=1:hs.Coeff_MvNorm_q,
    for d2=1:hs.Coeff_MvNorm_q,	% sum gamma_t * X_t X_t'
      Gammaxx(d1,d2)=Gamma*squeeze(sum(Bas(d1,:,:).*Bas(d2,:,:),2));
    end
    for d2=1:hs.Coeff_MvNorm_p, 	% sum gamma_t * Y_t X_t'
      Gammayx(d2,d1)=Gamma*squeeze(sum(Tar(d2,:,:).*Bas(d1,:,:),2));
      if d1<=hs.Coeff_MvNorm_p, 	% sum gamma_t * Y_t Y_t'
	Gammayy(d1,d2)=Gamma*squeeze(sum(Tar(d1,:,:).*Tar(d2,:,:),2));
      end
    end
  end
  
  %expectations of Phi and Sigma
  exptPhi=hs.Phi_Wish_alpha*hs.Phi_Wish_iB;
  exptSigma=hs.Sigma_Wish_alpha*hs.Sigma_Wish_iB;
  
  % Coefficient MvNormal Update
  Coeff_MvNorm_Sigma=exptSigma;
  Coeff_MvNorm_Phi=Gammaxx+exptPhi;
  
  
  Coeff_MvNorm_Omega=(Gammayx+hpr.Coeff_MvNorm_Omega*exptPhi)*...
      inv(Coeff_MvNorm_Phi);
  
  % Component Precisions Sigma
  Sigma_Wish_alpha=.5*(Gammasum*segs+hpr.Sigma_Wish_k+...
		       2*hpr.Sigma_Wish_alpha);
  
  tmpvar1=Gammayy-(2*Gammayx-hs.Coeff_MvNorm_Omega*Gammaxx)* ...
	  hs.Coeff_MvNorm_Omega';
  tmpvar2=trace(Gammaxx*hs.Coeff_MvNorm_iPhi)*hs.Coeff_MvNorm_iSigma;
  tmpvar3=(hs.Coeff_MvNorm_Omega-hpr.Coeff_MvNorm_Omega)*exptPhi*...
	  (hs.Coeff_MvNorm_Omega-hpr.Coeff_MvNorm_Omega)';
  tmpvar4=trace(exptPhi'*hs.Coeff_MvNorm_iPhi)*hs.Coeff_MvNorm_iSigma;
  
  Sigma_Wish_B=0.5*(tmpvar1+tmpvar2+tmpvar3+tmpvar4)+hpr.Sigma_Wish_B;
  
  % Regression Coefficient Precisions Phi
  Phi_Wish_alpha=hs.Phi_Wish_k/2+hpr.Phi_Wish_alpha;
  Phi_Wish_B=0.5*(hs.Coeff_MvNorm_Omega-hpr.Coeff_MvNorm_Omega)'...
      *exptSigma*(hs.Coeff_MvNorm_Omega-hpr.Coeff_MvNorm_Omega);
  Phi_Wish_B=Phi_Wish_B+0.5*trace(exptSigma*hs.Coeff_MvNorm_iSigma)*...
      hs.Coeff_MvNorm_iPhi+hpr.Phi_Wish_B;
  
  
  obsmodel.Coeff_MvNorm_Omega=Coeff_MvNorm_Omega;
  obsmodel.Coeff_MvNorm_Sigma=Coeff_MvNorm_Sigma;
  obsmodel.Coeff_MvNorm_iSigma=inv(Coeff_MvNorm_Sigma); 
  obsmodel.Coeff_MvNorm_Phi=Coeff_MvNorm_Phi;
  obsmodel.Coeff_MvNorm_iPhi=inv(Coeff_MvNorm_Phi);
  obsmodel.Sigma_Wish_alpha=Sigma_Wish_alpha;
  obsmodel.Sigma_Wish_B=Sigma_Wish_B;
  obsmodel.Sigma_Wish_iB=inv(Sigma_Wish_B);
  obsmodel.Phi_Wish_alpha=Phi_Wish_alpha;
  obsmodel.Phi_Wish_B=Phi_Wish_B;
  obsmodel.Phi_Wish_iB=inv(Phi_Wish_B);
  
