function [chmm] = txupdate (chmm,T)
% function [chmm] = txupdate (chmm,T)
% 
% Update initial state and state transition  models
% 
% T        lengths of individual blocks
% chmm     single chmm data structure

[Gamma,Xi]=gethsbeliefs(chmm);		% get counts

for c=1:chmm.NChains,
  % $$$ if obsupdate is set
  if chmm.train.txupdate(c),
    txmodel=getchain(chmm,c,'txmodel');
    txmodel=update(txmodel,Xi{c},Gamma{c},T);
    chmm=setchain(chmm,c,'txmodel',txmodel);
  end
end
