function [B] = obslike (chmm,c,Xtrain,n)
% function [B] = obslike (chmm,c,Xtrain,n)
%
% Evaluate likelihood of data given observation model
% 
% chmm       chmm  data structure
% c          subchain number
% Xtrain     Training data structure
% n          block index (time series data can be split into many blocks)
%
% B          Likelihood of N data points


obsmodel=getchain(chmm,c,'obsmodel');

for k=1:length(obsmodel), 
  Bk=like(obsmodel{k},Xtrain.block(n),k);
  if k==1,
    B=Bk;
  elseif size(B,1)~=size(Bk,1),
    error('Likelihood Dimensions mismatch');
  else
    B=cat(2,B,Bk);
  end
end

outlmodel=getchain(chmm,c,'outlmodel');

% check for outliers if specified
if isobject(outlmodel)
  Bk=like(outlmodel,Xtrain.block(n),k);
  B=cat(2,B,Bk);
end



