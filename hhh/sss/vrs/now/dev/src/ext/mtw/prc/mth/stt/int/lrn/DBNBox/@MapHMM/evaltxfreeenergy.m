function [txavLL,txlPri] = evaltxfreeenergy (hmm,T);
% [txavLL,txlPri] = evaltxfreeenergy(hmm,T);
%
% Computes the Free Energy of the state transition model part of HMM
% model
%
% INPUT
%
% T            lengths of individual blocks
% hmm          data structure 
%
% OUTPUT
%
% txavLL     averaged Log-Likelihood of data under model
% txlPri     Log-Likelihood of Model parameters under priors
  
  % get messages
  [Gamma,Xi]=gethsbeliefs(hmm);

  txavLL=[0];
  txlPri=[];
  
