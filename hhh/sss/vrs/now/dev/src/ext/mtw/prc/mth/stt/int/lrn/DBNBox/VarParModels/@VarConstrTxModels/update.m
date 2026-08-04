function [txmodel]=update(txmodel,Xi,Gamma,T,varargin)
% [txmodel]=update(txmodel,Xi,Gamma,T)
% updates hidden state parameters of an TXMODEL
% 
% INPUT:
%
% Xi     probability of past and future state cond. on data
% Gamma  probability of current state cond. on data
% K      state space dimension
% T      lengths of individual blocks
% txmodel    single txmodel data structure
%
% OUTPUT
% txmodel    single txmodel data structure with updated state model probs.



K=txmodel.K(txmodel.permvec);		% reshape to S_t,S_(t-1),rest
if length(K)>2,% MD -> 3-D for loop
  rK=[K(1) K(2) prod(K(3:end))];
else
  rK=[K(1) K(2) 1];% 2D -> 3-D for loop
end
  
% transition matrix 
sxi=squeeze(sum(Xi,1));   		% counts over time
sxi=permute(sxi,txmodel.permvec);
sxi=reshape(sxi,rK);			% make 3-dimensional

pr.Dir_alpha=txmodel.prior.Dir_alpha;
P=zeros(rK);

for p=1:rK(3)
  sdxi=sum(diag(sxi(:,:,p)));
  N=sum(sum(sxi(:,:,p)));
  Dir_alpha(1,p)=sdxi+pr.Dir_alpha(1,p);
  Dir_alpha(2,p)=N-sdxi+pr.Dir_alpha(2,p);
  PsiSum=digamma(sum(Dir_alpha(:,p)));
  if txmodel.options.jntmod
    tmpP=eye(rK(1))*(digamma(Dir_alpha(1,p))-PsiSum-log(rK(1)));
    tmpP=tmpP+(1-eye(rK(1)))*((digamma(Dir_alpha(2,p))-PsiSum)- ...
			      log(K(1)*(K(1)-1)));
    tmpP=exp(tmpP);
    P(:,:,p)=tmpP./sum(tmpP(:));
  else
    tmpP=eye(rK(1))*(digamma(Dir_alpha(1,p))-PsiSum);
    tmpP=tmpP+(1-eye(rK(1)))*((digamma(Dir_alpha(2,p))-PsiSum)-log(K(1)-1));
    tmpP=exp(tmpP);
    P(:,:,p)=cdiv(tmpP,csum(tmpP));
  end
end  

txmodel.Dir_alpha=Dir_alpha;
txmodel.P=ipermute(reshape(P,K),txmodel.permvec);

T=cumsum([0 T(1:end-1)])+1;			% indeces of block onset

% intial state
txmodel.Dir1d_alpha=txmodel.prior.Dir1d_alpha;
txmodel.Dir1d_alpha=txmodel.Dir1d_alpha+sum(Gamma(T(:),:),1);

PsiSum=digamma(sum(txmodel.Dir1d_alpha,2));
for i=1:rK(1),
  Pi(i)=exp(digamma(txmodel.Dir1d_alpha(i))-PsiSum);
end
txmodel.Pi=Pi./sum(Pi);
  
