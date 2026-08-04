function [timindices]=mtimes(varargin);
%  spi=LagOp*spi; 
%  
% increment space-time index by LagOperator
% 

  if  isa(varargin{1},'LagOperator') & isa(varargin{2},'SpaceTime');
    spi=varargin{2};
    LagOp=varargin{1};
  elseif isa(varargin{1},'SpaceTime') & isa(varargin{2},'LagOperator');
    spi=varargin{1};
    LagOp=varargin{2};
  else
    error('Operation defined only for SpaceTime classes.');
  end

  Lags=LagOp.Lag{spi.ch};
  Cha=LagOp.Cha{spi.ch};
  for l=1:length(Lags),
    newt=[Lags(l), Cha(l)]+spi;
    timindices{l}=newt;
  end



