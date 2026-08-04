function [avLL] = evalue (txmodel,Gamma);
% [modavLL] = evalue (txmodel,Gamma);
%
% Computes the Free Energy of the state sapce model part of the Mixture Model
% 
% INPUT
%
% Gamma        probability of states conditioned on data 
% txmodel      data structure 
%
% OUTPUT
%
% modavLL     averaged Log-Likelihood of data under model
%



avLL=0; 

Gammasum=sum(Gamma,1);
avLL=Gammasum(:)'*log(txmodel.P(:));
