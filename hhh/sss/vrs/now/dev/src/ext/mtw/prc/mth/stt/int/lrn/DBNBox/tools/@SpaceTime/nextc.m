function [spi]=nextc(spi)
%
%  spi=nextc(spi)
%  sets the  space-time index to next chain but same time step

[spi]=next(spi,[0 1]);