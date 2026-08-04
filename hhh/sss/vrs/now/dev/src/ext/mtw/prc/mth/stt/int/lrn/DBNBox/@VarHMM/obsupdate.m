function [hmm] = obsupdate (hmm,Xtrain)
% function [hmm] = obsupdate (hmm,Xtrain)
% 
% Update observation models
% 
% Xtrain        training data structure
% hmm           hmm data structure



% get messages
Gamma=gethsbeliefs(hmm);

% if obsupdate is set
if hmm.train.obsupdate,
  for k=1:length(hmm.obsmodel),
    hmm.obsmodel{k}=update(hmm.obsmodel{k},Xtrain,Gamma(:,k));
  end
end

% if outlier flag is set
if hmm.train.outlupdate
  if isobject(hmm.outlmodel)		% do you have an outlier model?
    k=hmm.K;				% last is outlier kernel
    hmm.outlmodel=update(hmm.outlmodel,Xtrain,Gamma(:,k));
  end 
end
   
