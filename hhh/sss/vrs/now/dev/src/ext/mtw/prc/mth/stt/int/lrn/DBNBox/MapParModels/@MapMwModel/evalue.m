function [avLL,lPri] = evalue (txmodel,Gamma);
% [modavLL,modKLdiv] = evalue (txmodel,Gamma);
%
% Computes the Free Energy of the state transition model part of the CHMM
% 
% INPUT
%
% Gamma        probability of states conditioned on data 
% txmodel      data structure 
%
% OUTPUT
%
% modavLL     averaged Log-Likelihood of data under model
% modKLdiv    Model parameters KL divergences
%



avLL=0; 

Gammasum=sum(Gamma,1);
avLL=Gammasum(:)'*log(txmodel.P(:));

lPri=dirichlet(txmodel.P(:),txmodel.prior.Dir_alpha(:),1);

