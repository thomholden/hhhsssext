function [spi]=prevt(spi)
%
%  spi=prevt(spi)
%  sets the  space-time index to previous time step but same chain

[spi]=next(spi,[-1 0]);