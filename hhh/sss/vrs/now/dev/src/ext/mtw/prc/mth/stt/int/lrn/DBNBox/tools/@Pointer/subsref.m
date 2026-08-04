function [val]=subsref(pntr,index)
% [val]=subsref(pntr,index)
%
% answers queries about objects addressed by pointers

evalstr=sprintf('global %s;',pntr.CA);
eval(evalstr);

evalstr=sprintf('%s{pntr.addr}',pntr.CA);
val=eval(evalstr);

l=length(index);
for i=1:l
  ndxi=index(i);
  switch ndxi.type
   case '()'
    val = val(ndxi.subs{:});
   case '{}'
    val = val{ndxi.subs{:}};
   case '.'
    evalstr=sprintf('[val]=val.%s;',ndxi.subs);
    evalstr2=sprintf('error(''Error referencing %s'')', ndxi.subs);
    eval(evalstr,evalstr2);
  end
end

