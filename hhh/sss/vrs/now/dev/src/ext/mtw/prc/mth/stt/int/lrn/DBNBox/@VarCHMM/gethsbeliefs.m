function [Gamma,Xi]=gethsbeliefs(chmm,varargin)
% [Gamma,Xi]=gethsbeliefs(chschain,chainno)
% 
% returns posterior beliefs of hidden state chains
% 
% chainno     chain number for which beliefs are requested
% 

[Gamma,Xi]=getbeliefs(chmm.chschain,varargin{:});