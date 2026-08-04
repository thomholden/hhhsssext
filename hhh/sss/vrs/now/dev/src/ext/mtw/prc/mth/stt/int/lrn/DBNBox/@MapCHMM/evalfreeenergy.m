function [FrEn] = evalfreeenergy (chmm,Xtrain,T)
% [FrEn] = evalfreeenergy (chmm,Xtrain,Gamma,Xi,T);
%
% Computes the Free Energy of an CHMM and of observation model
% 
% INPUT
%
% Xtrain       training data structure
% T            length of individual blocks
% Xi           joint probability of past&future states conditioned on data 
% chmm          data structure 
%
% OUTPUT
%
% FrEn estiamted variational free energy
%


% Entropy of initial state and Entropy of transitions

[Entr] = evalhsfreeenergy (chmm,T);

avLL=0;
lPri=[];


% Free energy terms for model including obs. model
% and state transition model
% avLL for hidden state parameters and KL-divergence
[txavLL,txlPri] = evaltxfreeenergy(chmm,T);

[modavLL,modlPri] = evalobsfreeenergy(chmm,Xtrain);

avLL=txavLL+modavLL;
lPri=[txlPri modlPri];

FrEn=[Entr -avLL +lPri];