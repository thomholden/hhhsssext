function [txmodel]=update(txmodel,Gamma,varargin)
% [txmodel]=update(txmodel,Gamma)
% updates hidden state parameters of an TXMODEL
% 
% INPUT:
%
% Gamma  probability of current state cond. on data
% txmodel    single txmodel data structure
%
% OUTPUT
% txmodel    single txmodel data structure with updated state model probs.

txmodel.Dir_alpha=txmodel.prior.Dir_alpha;
txmodel.Dir_alpha=txmodel.Dir_alpha+sum(Gamma,1);

PsiSum=digamma(sum(txmodel.Dir_alpha,2));
for i=1:txmodel.K,
  P(i)=exp(digamma(txmodel.Dir_alpha(i))-PsiSum);
end

txmodel.P=P;
  
