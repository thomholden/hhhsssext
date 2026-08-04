function [maxspi]=maxc(varargin)
%  maxspi=maxc(spi),
%  
% return an index with largest chain value it can attain, i.e.
% space index is set to the Space dimension 
%

  if isa(varargin{1},'SpaceTime') 
    
    [maxspi]=deal(varargin{:});	% assign variables
    maxspi.ch=maxspi.C;
    maxspi.tc=maxspi.ti*maxspi.C;
  else
    error('Require SpaceTime class object for Max function.');
  end
