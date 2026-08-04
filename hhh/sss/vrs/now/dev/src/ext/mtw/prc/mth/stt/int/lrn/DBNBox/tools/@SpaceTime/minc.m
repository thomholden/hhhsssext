function [maxspi]=minc(varargin)
%  maxspi=minc(spi),
%  
% return an index with  smallest chain value it can attain, i.e.
% space index is set to 1
%

  if isa(varargin{1},'SpaceTime') 
    
    [maxspi]=deal(varargin{:});	% assign variables
    maxspi.ch=1;
    maxspi.tc=maxspi.ti*maxspi.ch;
  else
    error('Require SpaceTime class object for Max function.');
  end
