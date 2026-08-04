function set(obj,prop_name,prop_value)
% [val]=set(obj,prop_name,prop_value)
%
% assings values to objects addressed by pointers

evalstr=sprintf('global %s;',obj.CA);
eval(evalstr);

evalstr=sprintf('%s{obj.addr}',obj.CA);
memval=eval(evalstr);

if isobject(memval)
  memval=set(memval,prop_name,prop_value);
  evalstr=sprintf('%s{obj.addr}=memval;',obj.CA);
  eval(evalstr);
else
   error('Invalid function handel or object handle');
end

