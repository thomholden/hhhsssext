function [val]=subsref(spi,index)
% [val]=subsref(dmulti,index)
%
% answers queries about Space-time object' data members


val=spi;
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

