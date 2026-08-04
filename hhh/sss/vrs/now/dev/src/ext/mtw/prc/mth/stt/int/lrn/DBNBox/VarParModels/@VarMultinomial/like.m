function [B] = like(obsmodel,Xtrain,varargin)
% function [B] = like(obsmodel,Xtrain)
%
% Evaluate likelihood of data for the Multinomial observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points

X=Xtrain.X; 
[T,ndim]=size(X);

B=zeros(T,1);

hs=obsmodel;
PsiDir_alphasum=digamma(sum(sum(hs.Dir_alpha)));
for d=1:ndim,
  for c=1:length(hs.cells(d,:))-1,
    ndx=(hs.cells(d,c)<=X(:,d) & X(:,d) <hs.cells(d,c+1));
    PsiDir_alpha=digamma(hs.Dir_alpha(d,c));
    B(ndx)=PsiDir_alpha-PsiDir_alphasum;
  end;
end;

B=exp(B);
