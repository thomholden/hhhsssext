function [flag]=le(varargin)
%  spiA<=spiB; 
%  
% test of less or equalness of two space-time indeces. Returns true of 
%    a) Space-Time dimensions are identical
%    b) space and time-indices of index A are smaller than those of index B

  flag=binop(varargin{:},'lt');