function [txavLL,txlPri] = evaltxfreeenergy (chmm,T);
% [txavLL,txlPri] = evaltxfreeenergy(chmm,T,N);
%
% Computes the Free Energy of the state transition model part of CHMM
% model
%
% INPUT
%
% T            lengths of individual blocks
% chmm         data structure 
%
% OUTPUT
%
% txavLL     averaged Log-Likelihood of data under model
% txlPri     Log-Likelihood of Model parameters under priors
  

txavLL=[0];
txlPri=[];

[Gamma,Xi]=gethsbeliefs(chmm);		% get messages

for c=1:chmm.NChains,
  txmodel=getchain(chmm,c,'txmodel');
  [ctxavLL,ctxlPri] = evalue(txmodel,Xi{c},Gamma{c},T);
  if chmm.train.txupdate(c)==1,
    txavLL=cat(2,txavLL,ctxavLL);
    txlPri=cat(2,txlPri,ctxlPri);
  end
end
txavLL=sum(txavLL);