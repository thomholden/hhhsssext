function [obsmodel] = update(obsmodel,Xtrain,Gamma,varargin)
% function [obsmodel] = update (obsmodel,Xtrain,Gamma)
% 
% Update sinusoidal observation model
% 
% Xtrain        training data structure
% Gamma         p(state given X)
% obsmodel      obsmodel data structure


Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);

p=obsmodel.p;				% model order
w=obsmodel.w;
Gamma=Gamma';
Gammasum=sum(Gamma);

x=[sin(w*[0:T-1]); cos(w*[0:T-1])];	% spectral basis
y=Xtrain';				% targets


hs=obsmodel;			% temporary structure
hpr=obsmodel.prior;			% temporary structure
% $$$ some stuff first
Gammaxx=zeros(hs.Coeff_MvNorm_q);
Gammayx=zeros(hs.Coeff_MvNorm_p,hs.Coeff_MvNorm_q);
for d=1:hs.Coeff_MvNorm_p,
  Gammayx(d,:)=(y(d,:).*Gamma)*x';
end
for d=1:hs.Coeff_MvNorm_q,
  Gammaxx(d,:)=(x(d,:).*Gamma)*x';
end

%expectations of Phi and Sigma
exptPhi=hs.Phi_Wish_alpha*inv(hs.Phi_Wish_B);
exptSigma=hs.Sigma_Wish_alpha*inv(hs.Sigma_Wish_B);

% Coefficient MvNormal Update
Coeff_MvNorm_Sigma=hs.Sigma_Wish_alpha*inv(hs.Sigma_Wish_B);
Coeff_MvNorm_Phi=Gammaxx+exptPhi;

Coeff_MvNorm_Omega=(Gammayx+hpr.Coeff_MvNorm_Omega*exptPhi)*...
    inv(Coeff_MvNorm_Phi);

% Component Precisions Sigma
Sigma_Wish_alpha=.5*(Gammasum+hpr.Sigma_Wish_k+...
		     2*hpr.Sigma_Wish_alpha);

dist=y-hs.Coeff_MvNorm_Omega*x;
tmpvar1=zeros(hs.Sigma_Wish_k);
for n=1:hs.Sigma_Wish_k,
  tmpvar1(n,:)=(dist(n,:).*Gamma)*dist';
end;
tmpvar2=Gamma*sum(x.*(inv(hs.Coeff_MvNorm_Phi)*x),1)';
tmpvar3=(hs.Coeff_MvNorm_Omega-hpr.Coeff_MvNorm_Omega)*exptPhi*...
	(hs.Coeff_MvNorm_Omega-hpr.Coeff_MvNorm_Omega)';

tmpvar4=trace(exptPhi'*inv(hs.Coeff_MvNorm_Phi))*...
	inv(hs.Coeff_MvNorm_Sigma);

Sigma_Wish_B=0.5*tmpvar1+0.5*tmpvar2*inv(hs.Coeff_MvNorm_Sigma)+...
    0.5*tmpvar3+0.5*tmpvar4+hpr.Sigma_Wish_B;

% Regression Coefficient Precisions Phi
Phi_Wish_alpha=hs.Phi_Wish_k/2+hpr.Phi_Wish_alpha;
Phi_Wish_B=0.5*(hs.Coeff_MvNorm_Omega-hpr.Coeff_MvNorm_Omega)'...
    *exptSigma*(hs.Coeff_MvNorm_Omega-hpr.Coeff_MvNorm_Omega);
Phi_Wish_B=Phi_Wish_B+0.5*trace(exptSigma*inv(hs.Coeff_MvNorm_Sigma))*...
    inv(hs.Coeff_MvNorm_Phi)+hpr.Phi_Wish_B;


obsmodel.Coeff_MvNorm_Omega=Coeff_MvNorm_Omega;
obsmodel.Coeff_MvNorm_Sigma=Coeff_MvNorm_Sigma;
obsmodel.Coeff_MvNorm_Phi=Coeff_MvNorm_Phi;
obsmodel.Sigma_Wish_alpha=Sigma_Wish_alpha;
obsmodel.Sigma_Wish_B=Sigma_Wish_B;
obsmodel.Phi_Wish_alpha=Phi_Wish_alpha;
obsmodel.Phi_Wish_B=Phi_Wish_B;

