function obj = set(obj,varargin)
% obj=set(obj,prop_name,prop_value)
%   OR
%  obj=set(obj,prop_name1,prop_name2,prop_name3,....,prop_value)  
%
% SET set property of the  specified object to a value

% hardcoded search upto three levels

% construct evaluation string
evalstr='obj';
Nargs=length(varargin);
for n=1:Nargs-1,
  evalstr=[evalstr '.' varargin{n}];
  if isobject(eval(evalstr)),		% reference to object
    evalstr=[evalstr '=set(' evalstr ',varargin{n+1:end});'];
    eval(evalstr);
    return;
  end
end

evalstr=[evalstr '=varargin{Nargs};'];

try 
  eval(evalstr);			% if ok set
catch					% else moan
  error(sprintf('Invalid Property "%s"',evalstr));	
end

