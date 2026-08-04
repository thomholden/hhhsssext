function [chschain,errmesg] = chngtopo (chschain,LagOpSpec);
% [chschain,errmesg] = chngtopo (chschain,LagOpSpec);
%
% Changes Topology of CHMM hidden state chain
%
% chschain	hidden chain data structure
% LagOpSpec     Specs of Topology
%


if chkcompat(chschain.LagOp,LagOpSpec),
  chschain.LagOpSpec=LagOpSpec;
  chschain.LagOp=LagOperator(LagOpSpec);
  errmesg='';
else
  errmesg='Topology mismatch: Could not convert!';
end
