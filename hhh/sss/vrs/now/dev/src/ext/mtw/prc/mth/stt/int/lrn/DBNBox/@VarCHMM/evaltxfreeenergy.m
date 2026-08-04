function [txavLL,txKLdiv] = evaltxfreeenergy (chmm,T);
% [txavLL,txKLdiv] = evaltxfreeenergy(chmm,T,N);
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
% txKLdiv    Model parameters KL divergences
  

txavLL=[0];
txKLdiv=[];

[Gamma,Xi]=gethsbeliefs(chmm);		% get messages

for c=1:chmm.NChains,
  txmodel=getchain(chmm,c,'txmodel');
  [ctxavLL,ctxKLdiv] = evalue(txmodel,Xi{c},Gamma{c},T);
  if chmm.train.txupdate(c)==1 | chmm.train.evalallfren==1
    txavLL=cat(2,txavLL,ctxavLL);
    txKLdiv=cat(2,txKLdiv,ctxKLdiv);
  end
end
txavLL=sum(txavLL);