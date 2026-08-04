function [txavLL] = evaltxfreeenergy (mix,T);
% [txavLL] = evaltxfreeenergy(mix,T);
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
  
  % get messages
  Gamma=gethsbeliefs(mix);

  txavLL=[0];

  [txavLL] = evalue(mix.txmodel,Gamma);

