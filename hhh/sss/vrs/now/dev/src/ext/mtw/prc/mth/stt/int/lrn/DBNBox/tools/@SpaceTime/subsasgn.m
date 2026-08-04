function [spi]=subsasgn(spi,index,val)
% subsasgn(spi,index,val)
%
% assigns values to Space-Time objects' data members
  
substr='spi';
valstr='=val;';

l=length(index);
for i=1:l
  ndxi=index(i);
  switch ndxi.type
    case '()'
      substr=sprintf('%s(%d',substr,ndxi.subs{:});
      valstr=[')' valstr];
    case '{}'
      substr=sprintf('%s{%d',substr,ndxi.subs{:});
      valstr=['}' valstr];
    case '.'
      substr=sprintf('%s.%s',substr,ndxi.subs);
  end
end

evalstr=[substr valstr];                      % set values
evalstr2=sprintf('error(''Error referencing %s'')', [substr valstr(1)]);
eval(evalstr,evalstr2);


spi.tc=spi.ti*spi.ch;
