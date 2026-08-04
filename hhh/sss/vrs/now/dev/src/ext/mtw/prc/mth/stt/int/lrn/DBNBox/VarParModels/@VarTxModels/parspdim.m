function [Npar]=parspdim(txmodel)
% [Npar]=uparspdim(txmodel)
%
% Count the number of parameters of the variational state transition
% model
% 
% 
% INPUT:
%
% txmodel    single txmodel data structure
%
% OUTPUT
%
% Npar       number of paramters.

Npar1=prod(txmodel.K);		% #pars of state transition prob. matrix
Npar2=txmodel.K(1);		% #pars of initial state prob.

Npar=Npar1+Npar2;
