function [obsmodel] = update(obsmodel,Xtrain,Gamma,varargin)
% function [obsmodel] = update(obsmodel,Xtrain,Gamma,varargin)
% 
% Update Poisson observation model
% 
% Xtrain        training data structure
% k             kernel index
% Gamma         p(state given X)
% obsmodel      obsmodel data structure

Xtrain=cat(1,Xtrain.block(:).X);
[T,ndim]=size(Xtrain);

hpr=obsmodel.prior;	% temporary structure

Gamma_alpha=sum(Gamma(:).*Xtrain(:,2),1)+hpr.Gamma_alpha;
Gamma_beta=sum(Gamma(:).*Xtrain(:,1),1)+hpr.Gamma_beta;

obsmodel.Gamma_alpha=Gamma_alpha;
obsmodel.Gamma_beta=Gamma_beta;
