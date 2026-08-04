function [mix] = obsupdate (mix,Xtrain)
% function [mix] = obsupdate (mix,Xtrain)
% 
% Update observation models
% 
% Xtrain        training data structure
% mix          mix data structure



% get messages
Gamma=gethsbeliefs(mix);

% if obsupdate is set
if mix.train.obsupdate,
  for k=1:length(mix.obsmodel),
    mix.obsmodel{k}=update(mix.obsmodel{k},Xtrain,Gamma(:,k));
  end
end

% if outlier flag is set
if mix.train.outlupdate
  if isobject(mix.outlmodel)		% do you have an outlier model?
    k=mix.K;				% last is outlier kernel
    mix.outlmodel=update(mix.outlmodel,Xtrain,Gamma(:,k));
  end 
end
   
