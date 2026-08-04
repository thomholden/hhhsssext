function [B] = like(obsmodel,Xtrain,varargin)
% function [B] = like(obsmodel,Xtrain)
%
% Evaluate likelihood of data for the Poisson observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points

X=Xtrain.X; 
[T,ndim]=size(X);

B=zeros(T,1);

logYfac=-gammaln(X(:,2)+1);		% -log(y_i!)
YlogX=X(:,2).*log(X(:,1));	% y_i log x_i

hs=obsmodel;
E_lograte=digamma(hs.Gamma_alpha)-log(hs.Gamma_beta); % <log(theta)>
E_rate=hs.Gamma_alpha./hs.Gamma_beta;
B=logYfac+YlogX+X(:,2).*E_lograte-X(:,1)*E_rate;

B=exp(B);

