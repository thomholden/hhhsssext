function [avLL,KLdiv] = evalue (txmodel,Gamma);
% [modavLL,modKLdiv] = evalue (txmodel,Gamma);
%
% Computes the Free Energy of the state transition model part of the CHMM
% 
% INPUT
%
% Gamma        probability of states conditioned on data 
% txmodel      data structure 
%
% OUTPUT
%
% modavLL     averaged Log-Likelihood of data under model
% modKLdiv    Model parameters KL divergences
%



avLL=0; 
PsiDir_alpha=zeros(1,txmodel.K);
% weigth prob total Psi
PsiDir_alphasum=digamma(sum(txmodel.Dir_alpha,2)); 
% weidht KL-div
KLdiv=dirichlet_kl(txmodel.Dir_alpha,txmodel.prior.Dir_alpha);

Dir_alpha=txmodel.Dir_alpha; 	% tmp var
for l=1:txmodel.K,
  % weigth Psi(alpha)
  PsiDir_alpha(l)=digamma(Dir_alpha(l));
  % weight avLL
  avLL=avLL+sum(Gamma(:,l)*(PsiDir_alpha(l)-PsiDir_alphasum));
end;

