function [Entr] = evalhsfreeenergy (chmm,T);
% [Entr] = evalhsfreeenergy(chmm,T);
%
% Computes the Free Energy of the state chain part of CHMM
%
% INPUT
%
% T             lengths of individual blocks
% chmm          data structure 
%
% OUTPUT
%
% Entr       entropy of hidden states

  
Entr=evalue(chmm.chschain,T);


