function [val]=get(obj,prop_name)
% [val]=get(obj,prop_name)
%
% answers queries about objects addressed by pointers

evalstr=sprintf('global %s;',obj.CA);
eval(evalstr);

evalstr=sprintf('%s{obj.addr}',obj.CA);
memval=eval(evalstr);

if isobject(memval)
   val=get(memval,prop_name);
else
   error('Invalid function handel or object handle');
end

