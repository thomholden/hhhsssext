function [obsmodel] = update(obsmodel,X,Gamma,varargin)
% function [obsmodel] = update(obsmodel,X,Gamma,varargin)
% 
% Update LIKE observation model
% 
% X             observations
% Gamma         p(state given X)
% obsmodel      obsmodel data structure


% The observations are themselves likelihoods
% There is no observation model to update

return
