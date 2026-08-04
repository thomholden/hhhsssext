function [pntr]=subsasgn(pntr,index,val)
% subsasgn(pntr,index,val)
%
% assigns values to objects addressed by pointers
  
evalstr=sprintf('global %s;',pntr.CA);           % access global memory
eval(evalstr);

evalstr=sprintf('%s{pntr.addr}',pntr.CA);        % fetch content
cont=eval(evalstr);

substr='cont';
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

evalstr=[substr valstr];      % set values
evalstr2=sprintf('error(''Error referencing %s'')', substr);
eval(evalstr,evalstr2);

evalstr=sprintf('%s{pntr.addr}=cont;',pntr.CA);     % replace old memory content
eval(evalstr);
