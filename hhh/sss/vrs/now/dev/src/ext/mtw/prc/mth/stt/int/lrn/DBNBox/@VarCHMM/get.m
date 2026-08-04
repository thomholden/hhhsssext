function val = get(obj,varargin)
%  obj=get(obj,prop_name)
%   OR
%  obj=get(obj,prop_name1,prop_name2,prop_name3,....)  
%
% GET Get property value of the specified object



% construct evaluation string
evalstr='obj';
Nargs=length(varargin);
for n=1:Nargs-1,
  evalstr=[evalstr '.' varargin{n}];
  if isobject(eval(evalstr)),		% reference to object
    val=get(eval(evalstr),varargin{n+1:end});
    return;
  end
end
evalstr=['val=' evalstr '.' varargin{Nargs} ';'];

try 
  eval(evalstr);			% if ok set
catch					% else moan
  error(sprintf('Invalid Property "%s"',evalstr));	
end


