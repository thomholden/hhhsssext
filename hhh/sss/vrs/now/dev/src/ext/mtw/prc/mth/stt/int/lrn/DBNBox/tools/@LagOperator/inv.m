function [iLagOp]=inv(varargin);
%  LagOp=inv(LagOp); 
%  
% convert 'Parent' LagOperator into 'Child' LagOperator
% 

  if  isa(varargin{1},'LagOperator'),
    LagOp=varargin{1};
  else
    error('Operation defined only for LagOperator.');
  end
  
  [iLagOp{1:LagOp.MaxCha}]=deal([]);

  for ch=1:LagOp.MaxCha,
    Lags=LagOp.Lag{ch};
    Cha=LagOp.Cha{ch}+ch;
    for l=1:length(Lags)
      iLagOp{Cha(l)}=cat(2,iLagOp{Cha(l)},[-1*Lags(l);ch]);
    end
  end
  iLagOp=LagOperator(iLagOp);
  
  

