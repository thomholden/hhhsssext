function [FrEn] = evalfreeenergy (hmm,Xtrain,T)
% [FrEn] = evalfreeenergy (hmm,Xtrain,T)
%
% Computes the KL divergence  of an HMM and of observation model
% 
% INPUT
%
% Xtrain       training data structure
% T            length of individual blocks
% N            number of blocks
% hmm          data structure 
%
% OUTPUT
%
% FrEn estiamted KL divergence
%


% Entropy of initial state and Entropy of transitions
[Entr] = evalhsfreeenergy (hmm,T);

% KL  terms for model including obs. model
% and state transition model
% avLL for hidden state parameters and parameter log-like
[txavLL,txlPri] = evaltxfreeenergy(hmm,T);
[modavLL,modlPri] = evalobsfreeenergy(hmm,Xtrain);

avLL=txavLL+modavLL;
lPri=[txlPri modlPri];

FrEn=[Entr -avLL -lPri];
