function val = getv(obj,varargin)
%  obj=getv(obj,prop_name)
%   OR
%  obj=getv(obj,prop_name1,prop_name2,prop_name3,....)  
%
% Verbose version GET Get property value of the specified object

% construct evaluation string
evalstr='obj';
Nargs=length(varargin);
for n=1:Nargs-1,
  evalstr=[evalstr '.' varargin{n}];
end
evalstr=['val=' evalstr '.' varargin{Nargs} ';'];
disp(['Evaluating: ' evalstr]);

try 
  eval(evalstr);			% if ok set
catch					% else moan
  error(sprintf('Invalid Property "%s"',evalstr));	
end


