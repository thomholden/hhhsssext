function [maxspi]=mint(varargin)
%  maxspi=mint(spi),
%  
% return an index with smallest time value it can attain, i.e.
% time index is set to 1
%

  if isa(varargin{1},'SpaceTime') 
    
    [maxspi]=deal(varargin{:});	% assign variables
    maxspi.ti=1;
    maxspi.tc=maxspi.ti*maxspi.ch;
  else
    error('Require SpaceTime class object for Max function.');
  end
