function [maxspi]=max(varargin)
%  maxspi=max(spi),
%  
% return an index with largest value it can attain, i.e.
% space and time index are set to the Space-Time dimensions 
%

  if isa(varargin{1},'SpaceTime') 
    
    [maxspi]=deal(varargin{:});	% assign variables
    maxspi.ti=maxspi.T;
    maxspi.ch=maxspi.C;
    maxspi.tc=maxspi.T*maxspi.C;
  else
    error('Require SpaceTime class object for Max function.');
  end
