function [FrEn] = evalfreeenergy (mix,Xtrain,T)
% [FrEn] = evalfreeenergy (mix,Xtrain,T)
%
% Computes the Free Energy of a mixture model
% 
% INPUT
%
% Xtrain       training data structure
% T            length of individual blocks
% N            number of blocks
% mix         data structure 
%
% OUTPUT
%
% FrEn estiamted variational free energy
%


% Entropy of initial state and Entropy of hidden states
[Entr] = evalhsfreeenergy (mix);

% Free energy terms for model including obs. model
% and state transition model
% avLL for hidden state parameters and KL-divergence
[txavLL] = evaltxfreeenergy(mix,T);
[modavLL] = evalobsfreeenergy(mix,Xtrain);

avLL=txavLL+modavLL;

FrEn=[Entr -avLL];
