function [B] = like(txmodel,Gamma);
% [B] = like(txmodel);
%
% Computes the average Log-Likelihood of data under model% 
% INPUT
%
% T            probability of states conditioned on data 
% txmodel      data structure 
%
% OUTPUT
%
% B            exponentiated averaged Log-Likelihood of data under model
%

K=txmodel.K;
B=zeros(1,K);
PsiDir_alpha=zeros(1,K);
% weigth prob total Psi

PsiDir_alphasum=digamma(sum(txmodel.Dir_alpha)); 

Dir_alpha=txmodel.Dir_alpha; 	% tmp var
for l=1:K,
  % weigth Psi(alpha)
  PsiDir_alpha(l)=digamma(Dir_alpha(l));
  % weight avLL
  B(l)=PsiDir_alpha(l)-PsiDir_alphasum;
end;

B=repmat(B,length(Gamma),1);

B=exp(B);
