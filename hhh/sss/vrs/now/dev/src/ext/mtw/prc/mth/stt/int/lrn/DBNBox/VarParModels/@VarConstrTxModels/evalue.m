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
K=txmodel.K(txmodel.permvec);		% reshape to S_t,S_(t-1),rest
if length(K)>2,% MD -> 3-D for loop
  rK=[K(1) K(2) prod(K(3:end))];
else
  rK=[K(1) K(2) 1];% 2D -> 3-D for loop
end

avLL=0; 

PsiDir1d_alpha=zeros(1,rK(1));
% initial state KL-div
KLdiv=dirichlet_kl(txmodel.Dir1d_alpha,txmodel.prior.Dir1d_alpha);
% initial state Psi
PsiDir1d_alphasum=digamma(sum(txmodel.Dir1d_alpha)); 
Dir1d_alpha=txmodel.Dir1d_alpha; 	% tmp var
for l=1:rK(1),
  % initial state Psi(alpha)
  PsiDir1d_alpha(l)=digamma(Dir1d_alpha(l));
  % intial state avLL
  avLL=avLL+sum(Gamma(T(:),l)*(PsiDir1d_alpha(l)-PsiDir1d_alphasum));
end

  
% transition matrix 
sxi=squeeze(sum(Xi,1));   		% counts over time
sxi=permute(sxi,txmodel.permvec);
sxi=reshape(sxi,rK);			% make 3-dimensional

% now state transition part
pr.Dir_alpha=txmodel.prior.Dir_alpha;
Dir_alpha=txmodel.Dir_alpha;
for p=1:rK(3)
  % KL-divergence for transition prob
  KLdiv=[KLdiv dirichlet_kl(Dir_alpha(:,p),pr.Dir_alpha(:,p))];
  sdxi=sum(diag(sxi(:,:,p)));
  N=sum(sum(sxi(:,:,p)));
  PsiSum=digamma(sum(Dir_alpha(:,p)));
  if txmodel.options.jntmod
    avLL=avLL+sdxi*(digamma(Dir_alpha(1,p))-PsiSum-log(rK(1)));
    avLL=avLL+(N-sdxi)*(digamma(Dir_alpha(2,p))-PsiSum-log(rK(1)*(rK(1)-1)));
  else
    avLL=avLL+sdxi*(digamma(Dir_alpha(1,p))-PsiSum);
    avLL=avLL+(N-sdxi)*(digamma(Dir_alpha(2,p))-PsiSum-log(rK(1)-1));
  end
end  


