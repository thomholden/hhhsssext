function [obsmodel] = update(obsmodel,Xtrain,Gamma,varargin)
% function [obsmodel] = update(obsmodel,Xtrain,Gamma,,varargin)
% 
% Update Multinomial observation model
% 
% Xtrain        training data structure
% Gamma         p(state given X)
% obsmodel           obsmodel data structure

Xtrain=cat(1,Xtrain.block(:).X);

[T,ndim]=size(Xtrain);

hs=obsmodel;			% temporary structure
hpr=obsmodel.prior;		% temporary structure
for d=1:ndim,
  for c=1:length(hs.cells(d,:))-1,
    ndx=((hs.cells(d,c)<=Xtrain(:,d)) & (Xtrain(:,d) <hs.cells(d,c+1)));
    hs.Dir_alpha(d,c)=sum(Gamma(find(ndx)))+hpr.Dir_alpha(d,c);
  end;
end;
obsmodel=hs;

