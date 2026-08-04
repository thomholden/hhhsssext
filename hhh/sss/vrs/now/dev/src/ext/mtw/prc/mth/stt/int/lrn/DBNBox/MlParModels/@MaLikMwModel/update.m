function [txmodel]=update(txmodel,Gamma,varargin)
% [txmodel]=update(txmodel,Gamma)
% updates hidden state parameters of an TXMODEL
% 
% INPUT:
%
% Gamma  probability of current state cond. on data
% txmodel    single txmodel data structure
%
% OUTPUT
% txmodel    single txmodel data structure with updated state model probs.


P=sum(Gamma,1);

txmodel.P=P./sum(P(:));
  
