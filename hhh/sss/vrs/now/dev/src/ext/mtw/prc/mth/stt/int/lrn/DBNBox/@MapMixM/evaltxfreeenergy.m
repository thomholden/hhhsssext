function [txavLL,txKLdiv] = evaltxfreeenergy (mix,T);
% [txavLL,txKLdiv] = evaltxfreeenergy(mix,T);
%
% Computes the Free Energy of the kernel weight model part of mixture models
% model
%
% INPUT
%
% T            lengths of individual blocks
% mix          data structure 
%
% OUTPUT
%
% txavLL     averaged Log-Likelihood of data under model
% txKLdiv    Model parameters KL divergences
  
  % get messages
  Gamma=gethsbeliefs(mix);

  txavLL=[0];
  txKLdiv=[];
  [txavLL,txKLdiv] = evalue(mix.txmodel,Gamma);

