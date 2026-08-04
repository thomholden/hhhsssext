function [obsmodel] = update (obsmodel,Xtrain,Gamma,varargin)
% function [obsmodel] = update (obsmodel,Xtrain,Gamma)
% 
% Update Autoregressive observation model
% 
% Xtrain        training data structure
% Gamma         p(state given X)
% obsmodel      obsmodel data structure

Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);

p=obsmodel.p;				% model order
Gamma=Gamma';
Gammasum=sum(Gamma);

x=membed(Xtrain(1:end-1,:),p,1)';	% basis (transp. for consistency...)
y=Xtrain([p+1:1:T],:)';			% targets (.. with paper)

hs=obsmodel;			% temporary structure
% $$$ some stuff first
Gammaxx=zeros(p);
Gammayx=zeros(ndim,p);
for d=1:ndim,
  Gammayx(d,:)=(y(d,:).*Gamma(p+1:1:T))*x';
end
for d=1:p,
  Gammaxx(d,:)=(x(d,:).*Gamma(p+1:1:T))*x';
end

% Coefficient
A=(Gammayx)*inv(Gammaxx);

% Noise Precision and Variance
dist=y-A*x;
tmpvar=zeros(ndim);
for n=1:ndim,
  tmpvar(n,:)=(dist(n,:).*Gamma(p+1:1:T))*dist';
end;
Cov=tmpvar./Gammasum;
Prec=inv(Cov);

obsmodel.A=A;
obsmodel.Prec=Prec;
obsmodel.Cov=Cov;

