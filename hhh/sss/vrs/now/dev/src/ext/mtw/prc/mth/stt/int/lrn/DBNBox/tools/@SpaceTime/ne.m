function [flag]=ne(varargin)
%  spiA~=spiB; 
%  
% test of equalness. Returns true if
%    a) space and time-indices are not identical, or
%    b) Space-Time dimensions are not identical

  flag=binop(varargin{:},'ne');

