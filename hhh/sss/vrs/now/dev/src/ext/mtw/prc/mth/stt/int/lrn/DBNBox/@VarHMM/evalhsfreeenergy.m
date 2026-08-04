function [Entr] = evalhsfreeenergy (hmm,T);
% [Entr] = evalhsfreeenergy(hmm,T);
%
% Computes the Free Energy of the state chain part of HMM
%
% INPUT
%
% T             lengths of individual blocks
% hmm           data structure 
%
% OUTPUT
%
% Entr       entropy of hidden states

  
Entr=evalue(hmm.hschain,T);

