function [txavLL] = evaltxfreeenergy (hmm,T);
% [txavLL] = evaltxfreeenergy(hmm,T);
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

  txavLL=[0];

  % get messages
  [Gamma,Xi]=gethsbeliefs(hmm);

  [txavLL] = evalue(hmm.txmodel,Xi,Gamma,T);

