function [txmodel]=update(txmodel,Xi,Gamma,N)
% [txmodel]=update(txmodel,Xi,Gamma,N)
% updates hidden state parameters of an TXMODEL
% 
% INPUT:
%
% Xi     probability of past and future state cond. on data
% Gamma  probability of current state cond. on data
% K      state space dimension
% N      number of blocks
% txmodel    single txmodel data structure
%
% OUTPUT
% txmodel    single txmodel data structure with updated state model probs.

K=txmodel.K;
% transition matrix 
sxi=squeeze(sum(Xi,1));   % counts over time
txmodel.Dir_alpha=sxi+txmodel.prior.Dir_alpha;
for j=1:K,
  PsiSum=digamma(sum(txmodel.Dir_alpha(j,:)));
  for i=1:K,
    P(j,i)=digamma(txmodel.Dir_alpha(j,i))-PsiSum;
  end;
end;
P=exp(P);
txmodel.P=P;
txmodel.P=rdiv(P,rsum(P));

T=size(Gamma,1)/N;			% number of blocks 

% intial state
txmodel.Dir1d_alpha=txmodel.prior.Dir1d_alpha;
txmodel.Dir1d_alpha=txmodel.Dir1d_alpha+sum(Gamma(1:T:N*T,:),1);

PsiSum=digamma(sum(txmodel.Dir1d_alpha,2));
for i=1:K,
  Pi(i)=exp(digamma(txmodel.Dir1d_alpha(i))-PsiSum);
end
txmodel.Pi=Pi./sum(Pi);
  
