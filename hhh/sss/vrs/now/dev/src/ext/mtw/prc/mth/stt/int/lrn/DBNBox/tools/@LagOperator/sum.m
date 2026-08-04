function [timindices]=sum(varargin);

%  spi=LagOp*spi; 
%  
% increment space-time index by LagOperator
% 

  if isa(varargin{1},'SpaceTime') & isa(varargin{2},'LagOperator');
    spi=varargin{1};
    LagOp=varargin{2};
  elseif  isa(varargin{1},'LagOperator') & isa(varargin{2},'SpaceTime');
    spi=varargin{2};
    LagOp=varargin{1};
  else
    error('Operation defined only for double.');
  end

  Lags=LagOp.Lag{spi.ch};
  Cha=LagOp.Cha{spi.ch};
  for l=1:length(Lags),
    li=Lags+spi.ti
    ci=Cha+spi.ch
    if any([li ci]<=0)
      newt=nan;
    elseif li>spi.T
      newt=nan;
    elseif ci>spi.C
      newt=nan;
    else
      newt=[Lags(l), Cha(l)]+spi;
    end
    timindices{l}=newt;
  end

return;  
  
  Lags=LagOp.Lag{t.ch};
  Cha=LagOp.Cha{t.ch};
  for l=1:length(Lags),
    [Lags(l), Cha(l)];
    newt=[Lags(l), Cha(l)]+t;
    timindices{l}=newt;
  end

