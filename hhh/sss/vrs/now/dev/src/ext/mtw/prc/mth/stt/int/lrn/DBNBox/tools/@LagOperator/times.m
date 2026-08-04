function [timindices]=times(varargin);
%  vec=LagOp.*vec; 
%  
% increment space-time vector by LagOperator
% 

  if isa(varargin{1},'double') & isa(varargin{2},'LagOperator');
    spiv=varargin{1};
    LagOp=varargin{2};
  elseif  isa(varargin{1},'LagOperator') & isa(varargin{2},'double');
    spiv=varargin{2};
    LagOp=varargin{1};
  else
    error('Operation defined only for double.');
  end
  
  spiv=spiv(:);
  if size(spiv,1)~=2, 
    error('Operation defined only for 2-by-1 double vector');
  end
  
  Lags=LagOp.Lag{spiv(2)};
  Cha=LagOp.Cha{spiv(2)};
  for l=1:length(Lags),
    newt=[Lags(l); Cha(l)]+spiv;
    timindices(:,l)=newt;
  end



