function [spi]=nextt(spi)
%
%  spi=nextt(spi)
%  sets the  space-time index to next time step but same chain

[spi]=next(spi,[1 0]);