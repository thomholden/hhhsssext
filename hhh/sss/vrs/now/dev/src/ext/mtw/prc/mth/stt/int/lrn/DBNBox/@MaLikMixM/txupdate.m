function [mix] = txupdate (mix,T)
% function [mix] = txupdate (mix,T)
% 
% Update initial state and state transition  models
% 
% T        lengths of individual blocks
% mix      single mix data structure


if mix.train.txupdate,
  % get messages
  [Gamma]=gethsbeliefs(mix);
  mix.txmodel=update(mix.txmodel,Gamma);
end

