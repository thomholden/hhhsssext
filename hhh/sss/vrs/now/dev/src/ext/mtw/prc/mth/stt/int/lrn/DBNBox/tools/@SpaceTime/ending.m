function [flag]=ending(spi)
%  ending(spi)
%  true if space-time index reach the end (Tmax,Cmax)
% 
  
  if spi.TC<=spi.elcntr,
    flag=1;
  else
    flag=0;
  end
