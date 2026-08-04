function [FrEn] = evalfreeenergy (hmm,Xtrain,T)
% [FrEn] = evalfreeenergy (hmm,Xtrain,T)
%
% Computes the Free Energy of an HMM and of observation model
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
% FrEn estiamted variational free energy
%


% Entropy of initial state and Entropy of transitions
[Entr] = evalhsfreeenergy (hmm,T);

% Free energy terms for model including obs. model
% and state transition model
% avLL for hidden state parameters and KL-divergence
[txavLL,txKLdiv] = evaltxfreeenergy(hmm,T);

[modavLL,modKLdiv] = evalobsfreeenergy(hmm,Xtrain);

avLL=txavLL+modavLL;
KLdiv=[txKLdiv modKLdiv];

FrEn=[Entr -avLL +KLdiv];