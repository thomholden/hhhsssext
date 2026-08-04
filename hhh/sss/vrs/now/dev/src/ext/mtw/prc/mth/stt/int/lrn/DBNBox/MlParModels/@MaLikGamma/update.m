function [obsmodel] = update (obsmodel,Xtrain,Gamma,varargin)
% function [obsmodel] = update (obsmodel,Xtrain,Gamma)
% 
% Update Gamma observation model
% 
% Xtrain        training data structure
% Gamma         p(state given X)
% obsmodel           obsmodel data structure
 
warning off MATLAB:fzero:UndeterminedSyntax
  
Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);
Gammasum=sum(Gamma);

hs=obsmodel;			% temporary structure

beta=(Gamma'*Xtrain)./(Gammasum.*hs.alpha);
beta=1./beta;

% alpha nees some 1-D root-search iterative approximation
alpha = fzero(@dLdalpha,[1,T],[],beta,Xtrain,Gamma);

obsmodel.alpha=alpha;
obsmodel.beta=beta;

return

function val=dLdalpha(A,B,X,Gamma)
% the derivative of the log-likelihood gamma pdf wrt to alpha
 
val=Gamma'*(log(B)-psi(A)+log(X));


