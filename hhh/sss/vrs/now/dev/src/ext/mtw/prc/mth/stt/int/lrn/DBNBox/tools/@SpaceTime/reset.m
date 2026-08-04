function [spi]=reset(spi)
  %
%  spi=reset(spi)
%  resets space-time index to beginning, also resets overflow flag
%  and element counter

  
spi.ovfl=0;
spi.elcntr=0;
spi.tc=1;
spi.ti=1;
spi.ch=1;
