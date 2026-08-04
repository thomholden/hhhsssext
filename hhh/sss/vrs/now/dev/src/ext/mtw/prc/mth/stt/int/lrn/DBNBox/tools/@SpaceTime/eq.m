function [flag]=eq(varargin)
%  spiA==spiB; 
%  
% test of equalness. Returns true of 
%    a) space and time-indices are identical
%    b) Space-Time dimensions are identical

  flag=binop(varargin{:},'eq');