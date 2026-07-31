function [str, strlength]=mvar2str(mvar);
%function [str, strlength]=mvar2str(mvar);
%
%   Converts a matlab variable to a string
%   so it can be transmitted over a port and
%   then restored. There is no need to write
%   the variable to a file. Restore the variable
%   using str2mvar( ). 
%
%   Supported classes: Arrays of double, char, 
%                      sruct, cell and sparse matrixes
%
%   Not supported classes: objects, single, uints, java
%
%    By Lucio Andrade. Feb 2001
%

sizes=size(mvar);
dimen=length(sizes);
[dimstr,prec]=int2serial(sizes);

if ((prod(sizes)==1) & (~issparse(mvar)) ) %for single data (reduces overhead)
   
   switch class(mvar)
   case 'char', str=[char(1);mvar];
   case 'double',
      if isreal(mvar) str=[char(2);double2serial(mvar)'];
      else str=[char(3);double2serial(real(mvar))';char(0);double2serial(imag(mvar))'];
      end %if isreal
   case 'cell',  
     [tmps,tmpl]=mvar2str(mvar{1});
     str=[char(4);int2serial(tmpl);tmps];
   case 'struct',
     fn=fieldnames(mvar); nf=length(fn);
     [tmps,tmpl]=mvar2str(fn);
     str=[char(5);int2serial(tmpl);tmps];
     for i=1:nf
        eval(['[tmps,tmpl]=mvar2str(mvar.' char(fn(i)) ');'])
        str=[str;int2serial(tmpl);tmps];
     end
   case 'int8',  str=[char(7);double2serial(double(mvar))'];
   case 'int16', str=[char(8);double2serial(double(mvar))'];
   case 'int32', str=[char(9);double2serial(double(mvar))'];
   case 'uint8', str=[char(10);double2serial(double(mvar))'];
   case 'uint16',str=[char(11);double2serial(double(mvar))'];
   case 'uint32',str=[char(12);double2serial(double(mvar))'];
   otherwise,       error(['Data class (' class(mvar) ') no supported !!!'])
   end
  
else               % this part is for any array size
   
   switch class(mvar)
   case 'char', str=[char(17);dimstr;mvar(:)];
   case 'double',   
     if isreal(mvar) str=[char(18);dimstr;double2serial(mvar)'];
     else str=[char(19);dimstr;double2serial(real(mvar))';char(0);double2serial(imag(mvar))'];
     end %if isreal
  case 'cell',
    str=[char(20);dimstr];
    for i1=1:size(mvar,1) for i2=1:size(mvar,2) for i3=1:size(mvar,3) 
    for i4=1:size(mvar,4) for i5=1:size(mvar,5)
       [tmps,tmpl]=mvar2str(mvar{i1,i2,i3,i4,i5});
       str=[str;int2serial(tmpl);tmps];
    end; end; end; end; end;
  case 'struct',  
     fn=fieldnames(mvar);nf=length(fn);
     [tmps,tmpl]=mvar2str(fn);
     str=[char(21);dimstr;int2serial(tmpl);tmps];
     for i1=1:size(mvar,1) for i2=1:size(mvar,2) for i3=1:size(mvar,3) 
     for i4=1:size(mvar,4) for i5=1:size(mvar,5)
       for i=1:nf
          idst=[num2str(i1) ',' num2str(i2) ',' num2str(i3) ',' num2str(i4) ',' num2str(i5)];    
          eval(['[tmps,tmpl]=mvar2str(mvar(' idst ').' char(fn(i)) ');'])
          str=[str;int2serial(tmpl);tmps];
     end; end; end; end; end; end;
   case 'sparse',
     str=[char(22);dimstr];
     [i_r,j_r,s_r]=find(real(mvar));
     str=[str;int2serial(i_r(:));int2serial(j_r(:))];
     [tmps,tmpl]=mvar2str(s_r(:));
     str=[str;int2serial(tmpl);tmps];
     [i_i,j_i,s_i]=find(imag(mvar));
     str=[str;int2serial(i_i(:));int2serial(j_i(:))];
     [tmps,tmpl]=mvar2str(s_i(:));
     str=[str;int2serial(tmpl);tmps];
   case 'int8',  str=[char(23);dimstr;double2serial(double(mvar))'];
   case 'int16', str=[char(24);dimstr;double2serial(double(mvar))'];
   case 'int32', str=[char(25);dimstr;double2serial(double(mvar))'];
   case 'uint8', str=[char(26);dimstr;double2serial(double(mvar))'];
   case 'uint16',str=[char(27);dimstr;double2serial(double(mvar))'];
   case 'uint32',str=[char(28);dimstr;double2serial(double(mvar))'];
   otherwise, error(['Data class (' class(mvar) ') no supported !!!'])
  end
  
end

strlength=length(str);

function [str,prec]=int2serial(a)
%function [str,prec]=int2serial(a)

if (sum(size(a)>1)>1) error('Input must be vector o column'); end;

le=length(a);
q=dec2hex(a);
q=[dec2hex(zeros(size(q,1),rem(size(q,2),2))) q]; %refill to have bytes
prec=char(size(q,2)/2);prec=prec+~prec;
datstr=char(hex2dec(reshape(q',2,le*prec)'));
datlen=length(datstr);

if prec>8 error('Do not have space for prec !'); end

if (a<128) & (le==1)
  str=char(a);
else
  str=128+(prec-1)*16;
  if le<8
    str=str+le;
  else
    lstr=char(hex2dec(reshape(dec2hex(le,10),2,5)'));
    lstr=lstr(find(cumsum(lstr)));
    str=str+8+length(lstr);
    str=[char(str);lstr];
  end
  str=[char(str);datstr];
end
    
    
   