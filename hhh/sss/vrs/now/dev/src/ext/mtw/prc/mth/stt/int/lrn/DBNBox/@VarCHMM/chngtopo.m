function [chmm] = chngtopo (chmm,LagOpSpec)
% function [chmm] = chngtopo (chmm,LagOpSpec)
% Changes Topology of CHMM hidden state chain
%
% chmm	chmm data structure
% 
%

[chmm.chschain,errmesg]=chngtopo(chmm.chschain,LagOpSpec);
if isempty(errmesg)
  chmm.LagOpSpec=LagOpSpec;
end;


  
