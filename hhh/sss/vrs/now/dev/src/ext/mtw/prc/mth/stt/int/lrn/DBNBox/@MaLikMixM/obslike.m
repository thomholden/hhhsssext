function [B] = obslike (mix,Xtrain,n)
% function [B] = obslike (mix,Xtrain,n)
%
% Evaluate likelihood of data given observation model
% 
% Xtrain     Training data structure
% n          block index (time series data can be split into many blocks)
% mix        mix  data structure
%
% B          Likelihood of N data points

for k=1:length(mix.obsmodel), 
  Bk=like(mix.obsmodel{k},Xtrain.block(n),k);
  if k==1,
    B=Bk;
  elseif size(B,1)~=size(Bk,1),
    error('Likelihood Dimensions mismatch');
  else
    B=cat(2,B,Bk);
  end
end

% check for outliers if specified
if isobject(mix.outlmodel)
  Bk=like(mix.outlmodel,Xtrain.block(n),k);
  B=cat(2,B,Bk);
end

