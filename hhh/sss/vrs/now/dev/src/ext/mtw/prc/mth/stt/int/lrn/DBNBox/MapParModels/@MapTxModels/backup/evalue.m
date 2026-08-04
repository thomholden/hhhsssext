function [avLL,KLdiv] = evalue (txmodel,T,N,Gamma,Xi);
% [modavLL,modKLdiv] = evalue (txmodel,Gamma,Xi);
%
% Computes the Free Energy of the state transition  model part of the HMM
% 
% INPUT
%
% Xi           joint probability of past&future states conditioned on data 
% Gamma        probability of states conditioned on data 
% txmodel      data structure 
% T             length of series
% N            number of blocks
%
% OUTPUT
%
% modavLL     averaged Log-Likelihood of data under model
% modKLdiv    Model parameters KL divergences
%

K=txmodel.K;



% Free energy terms for model not including obs. model
% avLL for hidden state parameters and KL-divergence
avLL=0; 
PsiDir_alpha=zeros(K,K);
PsiDir1d_alpha=zeros(1,K);
% initial state Psi
PsiDir1d_alphasum=digamma(sum(txmodel.Dir1d_alpha,2)); 
% initial state KL-div
KLdiv=dirichlet_kl(txmodel.Dir1d_alpha,txmodel.prior.Dir1d_alpha);
for l=1:K,
  % KL-divergence for transition prob
  KLdiv=[KLdiv dirichlet_kl(txmodel.Dir_alpha(l,:),txmodel.prior.Dir_alpha(l,:))];
  % initial state Psi(alpha)
  PsiDir1d_alpha(l)=digamma(txmodel.Dir1d_alpha(l));
  avLL=avLL+sum(Gamma(1:T:N*T,l)*(PsiDir1d_alpha(l)-PsiDir1d_alphasum));
  PsiDir_alphasum(l)=digamma(sum(txmodel.Dir_alpha(l,:)));
  for k=1:K,
    PsiDir_alpha(l,k)=digamma(txmodel.Dir_alpha(l,k));
   avLL=avLL+sum(Xi(:,l,k),1)*(PsiDir_alpha(l,k)-PsiDir_alphasum(l));
  end;
end;
