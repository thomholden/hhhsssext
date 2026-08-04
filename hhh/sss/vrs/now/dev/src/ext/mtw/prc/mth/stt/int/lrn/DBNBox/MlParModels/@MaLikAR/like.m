function [B] = like (obsmodel,Xtrain,varargin)
% function [B] = like (obsmodel,Xtrain)
%
% Evaluate likelihood of data given a Autoregressive observation model
% 
% Xtrain     block of training data structure
% obsmodel   obsmodel data structure
%
% B          Likelihood of N data points

Xtrain=Xtrain.X;
[T,ndim]=size(Xtrain);

p=obsmodel.p;			% model order

x=membed(Xtrain(1:end-1,:),p,1)';	% basis (transp. for consistency...)
y=Xtrain([p+1:1:T],:)';			% targets (.. with paper)

B=zeros(T,1);

hs=obsmodel;
ldetC=0.5*log(det(hs.Prec));

dist=mdist(y,hs.A*x,hs.Prec);
      
B(p+1:T)=ldetC+dist-ndim/2*log(2*pi);

% make B equal length to training data
B(1:p)=B(p+1:2*p);			% just repeat the beginning

B=exp(B);

