function [spi]=prev(spi)
%
%  spi=prev(spi)
%  sets the  space-time index to previous in fashion defined by its type

[spi]=next(spi,-1);