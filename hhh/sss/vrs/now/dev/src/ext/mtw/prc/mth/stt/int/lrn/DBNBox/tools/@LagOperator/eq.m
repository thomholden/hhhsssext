function [flag]=eq(varargin);

%  flag=LagOpA==LagOpA; 
%  
%  Compares if LagOperators A and B are identical
% 

  if ~isa(varargin{1},'LagOperator') | ~isa(varargin{2},'LagOperator');
    error('Operation defined only for 2 LagOperator objects.');
  end
  LagOpA=varargin{1};
  LagOpB=varargin{2};

  flag=1;				% assume true

  if LagOpA.MaxLag~=LagOpB.MaxLag
    flag=0; return;
  end
  
  if LagOpA.MaxCha~=LagOpB.MaxCha
    flag=0; return;
  end
  
  if any(LagOpA.Lag{:}~=LagOpB.Lag{:})
    flag=0; return;
  end

  if any(LagOpA.Cha{:}~=LagOpB.Cha{:})
    flag=0; return;
  end
  
