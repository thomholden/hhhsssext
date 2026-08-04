function [B] = like(txmodel,Gamma);
% [B] = like(txmodel);
%
% Computes the average Log-Likelihood of data under model
% INPUT
%
% T            probability of states conditioned on data 
% txmodel      data structure 
%
% OUTPUT
%
% B            exponentiated averaged Log-Likelihood of data under model
%

K=txmodel.K;

B=reshape(txmodel.P,1,K);


B=repmat(B,length(Gamma),1);
