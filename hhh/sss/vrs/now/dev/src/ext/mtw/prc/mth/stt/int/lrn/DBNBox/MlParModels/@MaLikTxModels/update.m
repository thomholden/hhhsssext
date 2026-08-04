function [txmodel]=update(txmodel,Xi,Gamma,T,varargin)
% [txmodel]=update(txmodel,Xi,Gamma,T)
% updates hidden state parameters of an TXMODEL
% 
% INPUT:
%
% Xi     probability of past and future state cond. on data
% Gamma  probability of current state cond. on data
% K      state space dimension
% T      lengths of individual blocks
% txmodel    single txmodel data structure
%
% OUTPUT
% txmodel    single txmodel data structure with updated state model probs.


% transition matrix 
sxi=squeeze(sum(Xi,1));   		% counts over time
P=sxi;

P=reshape(P,[txmodel.K(1) prod(txmodel.K(2:end))]);% -> 2-D for loop
P=cdiv(P,csum(P));			% make transition prob
txmodel.P=reshape(P,txmodel.K);		% reshape to normal


T=cumsum([0 T(1:end-1)])+1;			% indeces of block onset

% intial state
Pi=sum(Gamma(T(:),:),1);
txmodel.Pi=Pi./sum(Pi);
  
