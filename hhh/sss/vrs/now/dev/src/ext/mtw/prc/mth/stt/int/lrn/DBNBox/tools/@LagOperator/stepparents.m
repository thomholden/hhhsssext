function [timindices]=stepparents(varargin);
%  spi=stepparents(LagOp,spi); 
%  
% increment space-time index by LagOperator and return only parents not 
% belonging to the same chain
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
  
  ndx=find(Cha~=0);			% those not of the same chain
  
  Cha=Cha(ndx);				% need only subset
  Lags=Lags(ndx);
  
  for l=1:length(Lags),
    newt=[Lags(l), Cha(l)]+spi;
    timindices{l}=newt;
  end



