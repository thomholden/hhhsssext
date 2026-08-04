function [obj]=LagOperator(varargin)
% Constructor for Lag Operator Class
%  [LagOp]=LagOperator(LagSpec)
%  
% Data Members
%  MaxLag      largets Time index
%  MacCha      largest Chain index
%  Lag{c}      Lag specs for Chain <c>  largest Space-Time index
%  Cha         Cha specs corresponging to Lag 
%  
% Methods
%   mtimes()   operation of LagOp on SpaceTime index
%   inv()      invert LagOperator from Parent to Child description
%   
%   e.g.
%   
%  LagSpec{1}=[-1 -1 -2  -1 -2; 1 2 2 3 3];
%  LagSpec{2}=[-2  -1 -1; 1 2 3];
%  LagSpec{3}=[-2 -1 -1; 1 2  3];
%  LagOp=LagOp(LagSpec);
%   
  
  
  
  
ClassName='LagOperator';

defstruct=struct('MaxLag',[1],'MaxCha',[],'Lag',{{[-1]}},'Cha',{{[0]}});

if nargin==0
    obj=defstruct;
    obj=class(obj,ClassName);
else
    % argument is of same class, 
    if isa(varargin{1},ClassName)
        obj=varargin{1};			% just return;
        return;
    else
        obj=defstruct;
        [Lags]=mydeal(varargin{:});
	
        % Assign Lags to Lag and Chain to Cha; Find lagest Lag and Chain index
        if ~isempty(Lags)
	  MaxLag=-inf;MaxCha=length(Lags);
	  for l=1:length(Lags),
	    if ~isempty(Lags{l}),
	      obj.Lag{l}=Lags{l}(1,:);
	      obj.Cha{l}=Lags{l}(2,:)-l;
	      MaxLag=max(MaxLag,max(abs(obj.Lag{l})));
	      MaxCha=max(MaxCha,max(abs(obj.Cha{l})));
	    else
	      obj.Lag{l}=[-1];
	      obj.Cha{l}=[l-l];
	    end
	  end
	  obj.MaxLag=MaxLag;
	  obj.MaxCha=MaxCha;
        end;
        
        obj = class(obj,ClassName);
    end;
end;


