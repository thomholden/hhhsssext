function [flag] = chkcompat (chschain,LagOpSpec);
% [flag] = chkcompat (chschain,LagOpSpec);
%
% Checks for dimensionally compatilible Topology of CHMM hidden state chain
% returns 1 if compatible
%
% chschain	hidden chain data structure
% LagOpSpec     Specs of Topology
%


flag=chkcompat(chschain.LagOp,LagOpSpec);
