function [flag] = chkcompat (chmm,LagOpSpec)
% function [flag] = chkcompat (chmm,LagOpSpec)
% Checks for dimensionally compatilible Topology of CHMM hidden state chain
% returns 1 if compatible
%
% chmm	chmm data structure
% LagOpSpec new topology specs
%


[flag]=chkcompat(chmm.chschain,LagOpSpec);



 