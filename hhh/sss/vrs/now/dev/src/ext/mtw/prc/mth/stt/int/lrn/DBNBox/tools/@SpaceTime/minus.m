function [spi]=minus(varargin)
%  spi=spi-1;  or 
%  spi=spi-[1 1];			
% decrement space-time index by real number <d> or vector of from [time
% index,space index]
% 

  if isa(varargin{1},'SpaceTime') & isa(varargin{2},'double');
    spi=varargin{1};
    d=varargin{2};
  elseif  isa(varargin{1},'double') & isa(varargin{2},'SpaceTime');
    spi=varargin{2};
    d=varargin{1};
  else
    error('Operation defined only for double.');
  end
  
   spi=spi+(-d);