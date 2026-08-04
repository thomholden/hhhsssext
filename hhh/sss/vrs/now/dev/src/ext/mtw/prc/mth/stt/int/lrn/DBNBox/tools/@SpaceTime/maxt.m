function [maxspi]=maxt(varargin)
%  maxspi=maxt(spi),
%  
% return an index with largest time value it can attain, i.e.
% time index is set to the Time dimension 
%

  if isa(varargin{1},'SpaceTime') 
    
    [maxspi]=deal(varargin{:});	% assign variables
    maxspi.ti=maxspi.T;
    maxspi.tc=maxspi.T*maxspi.ch;
  else
    error('Require SpaceTime class object for Max function.');
  end
