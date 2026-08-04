function [spi]=prevc(spi)
%
%  spi=prevc(spi)
%  sets the  space-time index to previous chain but same time step

[spi]=next(spi,[0 -1]);