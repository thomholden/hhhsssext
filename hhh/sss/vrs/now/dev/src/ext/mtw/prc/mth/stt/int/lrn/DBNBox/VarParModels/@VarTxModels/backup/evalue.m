function [avLL,KLdiv] = evalue (txmodel,Xi,Gamma,T,varargin);
% [modavLL,modKLdiv] = evalue (txmodel,Xi,Gamma,T);
%
% Computes the Free Energy of the state transition model part of the CHMM
% 
% INPUT
%
% Xi           joint probability of past&future states conditioned on data 
% Gamma        probability of states conditioned on data 
% txmodel      data structure 
% T            lengths of individual blocks
%
% OUTPUT
%
% modavLL     averaged Log-Likelihood of data under model
% modKLdiv    Model parameters KL divergences
%



T=cumsum([0 T(1:end-1)])+1;			% indeces of block onset
K=[txmodel.K(1) prod(txmodel.K(2:end))]; % MD -> 2-D for loop
szXi=size(Xi);				% size of Xi
Xi=reshape(Xi,[szXi(1), K]); 		% assumes szXi(2:end) <-> K


avLL=0; 
PsiDir_alpha=zeros(K);
PsiDir1d_alpha=zeros(1,K(1));
% initial state Psi
PsiDir1d_alphasum=digamma(sum(txmodel.Dir1d_alpha,2)); 
% initial state KL-div
KLdiv=dirichlet_kl(txmodel.Dir1d_alpha,txmodel.prior.Dir1d_alpha);

Dir1d_alpha=txmodel.Dir1d_alpha; 	% tmp var
Dir_alpha=reshape(txmodel.Dir_alpha,K); % tmp var; reshaped
pr.Dir_alpha=reshape(txmodel.prior.Dir_alpha,K); % tmp var; reshaped
for l=1:K(1),
  % KL-divergence for transition prob
  KLdiv=[KLdiv dirichlet_kl(Dir_alpha(l,:),pr.Dir_alpha(l,:))];
  % initial state Psi(alpha)
  PsiDir1d_alpha(l)=digamma(Dir1d_alpha(l));
  % intial state avLL
  avLL=avLL+sum(Gamma(T(:),l)*(PsiDir1d_alpha(l)-PsiDir1d_alphasum));
  % state transition Psi(alpha)
  PsiDir_alphasum(l)=digamma(sum(Dir_alpha(l,:)));
  for k=1:K(2),
    PsiDir_alpha(l,k)=digamma(Dir_alpha(l,k));
    avLL=avLL+sum(Xi(:,l,k),1)*(PsiDir_alpha(l,k)-PsiDir_alphasum(l));
  end;
end;

