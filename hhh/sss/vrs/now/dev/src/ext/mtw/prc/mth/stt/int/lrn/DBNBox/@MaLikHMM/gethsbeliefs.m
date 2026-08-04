function [Gamma,Xi]=gethsbeliefs(hmm,varargin)
% [Gamma,Xi]=gethsbeliefs(chschain,chainno)
% 
% returns posterior beliefs of hidden state chain
% 
% chainno     chain number for which beliefs are requested
% 

[Gamma,Xi]=getbeliefs(hmm.hschain,varargin{:});
