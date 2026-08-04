function [flag]=overflow(spi)
%  overflow(spi)
%  true if space-time index has wrapped once Tmax and Cmax,
%  ie. joint index > Tmax*Cmax
  
  if spi.ovfl
    flag=1;
  else
    flag=0;
  end
