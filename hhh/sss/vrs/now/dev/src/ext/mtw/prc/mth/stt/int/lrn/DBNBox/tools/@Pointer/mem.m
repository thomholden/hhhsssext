function [val]=mem(obj)
% [val]=mem(obj)
%
% returns the entire object (equiv to memory block) referenced by pointers

evalstr=sprintf('global %s;',obj.CA);
eval(evalstr);

evalstr=sprintf('%s{obj.addr}',obj.CA);
val=eval(evalstr);

