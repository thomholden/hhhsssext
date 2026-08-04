function [txavLL,txKLdiv] = evaltxfreeenergy (hmm,T);
% [txavLL,txKLdiv] = evaltxfreeenergy(hmm,T);
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
% txKLdiv    Model parameters KL divergences
  
  % get messages
  [Gamma,Xi]=gethsbeliefs(hmm);

  txavLL=[0];
  txKLdiv=[];
  
  [txavLL,txKLdiv] = evalue(hmm.txmodel,Xi,Gamma,T);  

  txKLdiv=[];
