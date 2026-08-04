function [hmm] = txupdate (hmm,T)
% function [hmm] = txupdate (hmm,T)
% 
% Update initial state and state transition  models
% 
% T        lengths of individual blocks
% hmm      single hmm data structure


if hmm.train.txupdate,
  % get messages
  [Gamma,Xi]=gethsbeliefs(hmm);
  hmm.txmodel=update(hmm.txmodel,Xi,Gamma,T);
end

