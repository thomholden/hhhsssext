function [chmm] = obsupdate (chmm,Xtrain)
% function [chmm] = obsupdate (chmm,Xtrain)
% 
% Update observation models
% 
% Xtrain        training data structure
% chmm          chmm data structure



for c=1:chmm.NChains,
  Gamma=gethsbeliefs(chmm,c);		% get weights

  if chmm.train.obsupdate(c),		%  if obsupdate is set
    obsmodel=getchain(chmm,c,'obsmodel');
    for k=1:length(obsmodel),
      obsmodel{k}=update(obsmodel{k},Xtrain(c),Gamma(:,k));
    end
    chmm=setchain(chmm,c,'obsmodel',obsmodel);
  end

  if chmm.train.outlupdate(c),		%  if outlier flag is set
    outlmodel=getchain(chmm,c,'outlmodel');
    if isobject(outlmodel)		% do you have an outlier model?
      k=hmm.K;				% last is outlier kernel
      outlmodel=update(outlmodel,Xtrain(c),Gamma(:,k));
    end 
    chmm=setchain(chmm,c,'outlmodel',outlmodel);
  end
  
end

