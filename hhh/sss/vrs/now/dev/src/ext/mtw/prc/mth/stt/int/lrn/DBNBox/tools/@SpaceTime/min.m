function [spi]=min(spi)
  %
%  spi=min(spi)
%  resets space-time index to beginning, also resets overflow flag
%  and element counter
%  see reset.m

  
spi=reset(spi);
