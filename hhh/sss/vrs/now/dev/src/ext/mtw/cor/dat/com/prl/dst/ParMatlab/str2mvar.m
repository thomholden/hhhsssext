function mvar=str2mvar(str);
%function mvar=str2mvar(str);
%
%   Converts a string to a matlab variable using
%   the conventions defined in mvar2str( )
%
%    By Lucio Andrade. Feb 2001
%


clase=double(str(1));

if clase<16  % only a single value !!!
  dimen=1;prec=1;sizes=[1 1 1 1 1];
  datastartat=2;arraysize=8;

else % extract array info from the string

  [sizes,datastartat,prec]=serial2int(str,2);
  sizes=[sizes' 1 1 1 1 1];sizes=sizes(1:5);

end

clase=rem(clase,16);  %the following serves for single data or arrays

if (clase==1 | clase==2 | clase==3)
      mvar=zeros(sizes);    %allocating needed memory
elseif clase==4
      mvar=cell(sizes);
elseif (clase==7 | clase==8 | clase==9 | clase==10 | clase==11 | clase==12 )
      mvar=zeros(sizes);    %allocating needed memory for ints
elseif clase==5
   %I do not initialize for struct, its slower but it works
elseif clase==6
     mvar=sparse(sizes(1),sizes(2));
else
  error('String format invalid !!!, report error to landrade@ece.neu.edu')
end


endstr=length(str);   

switch clase
case 1, %for char
   mvar=char(mvar);
   mvar(:)=str(datastartat:endstr);
case 2,   %for real double
   buff=str(datastartat:endstr);
   mvar(:)=serial2double(buff);
case 3,  %for complex double
   endreal=max(find(str==char(0))); %the last zero separates the imag data
   buff=str(datastartat:endreal-1);
   mvar(:)=serial2double(buff);
   buff=[str(endreal+1:endstr)];
   mvar(:)=mvar(:)+serial2double(buff)*i;
case 4,  %for cells
    for i1=1:sizes(1) 
    for i2=1:sizes(2) 
    for i3=1:sizes(3) 
    for i4=1:sizes(4) 
    for i5=1:sizes(5)
      [strl,datastartat]= serial2int(str,datastartat);
      buff=str(datastartat:datastartat+strl-1);
      datastartat=datastartat+strl;
      mvar{i1,i2,i3,i4,i5}=str2mvar(buff);
    end;end;end;end;end;
case 5,  %for structs 
    [strl,datastartat]=serial2int(str,datastartat);
    buff=str(datastartat:datastartat+strl-1);
    datastartat=datastartat+strl;  
    fn=str2mvar(buff);nf=length(fn);
    for i1=1:sizes(1) 
    for i2=1:sizes(2) 
    for i3=1:sizes(3) 
    for i4=1:sizes(4) 
    for i5=1:sizes(5)
    for i=1:nf  
       idst=[num2str(i1) ',' num2str(i2) ',' num2str(i3) ',' num2str(i4) ',' num2str(i5)];    
       [strl,datastartat]= serial2int(str,datastartat);
       buff=str(datastartat:datastartat+strl-1);
       datastartat=datastartat+strl;
       eval(['mvar(' idst ').' char(fn(i)) '= str2mvar(buff);'])
    end;end;end;end;end;end;
case 6,  %for sparse 
   [i_r,datastartat]=serial2int(str,datastartat);
   [j_r,datastartat]=serial2int(str,datastartat);
   [strl,datastartat]=serial2int(str,datastartat);
   buff=str(datastartat:datastartat+strl-1);
   datastartat=datastartat+strl;
   s_r=str2mvar(buff)';
   n_r=length(i_r);
   
   if n_r mvar(sub2ind(sizes([1,2]),i_r,j_r))=s_r(:); end
 
   [i_i,datastartat]=serial2int(str,datastartat);
   [j_i,datastartat]=serial2int(str,datastartat);
   [strl,datastartat]=serial2int(str,datastartat);
   buff=str(datastartat:datastartat+strl-1);
   datastartat=datastartat+strl;
   s_i=str2mvar(buff)';
   n_i=length(i_i); 
 
   if n_i 
    mvar(sub2ind(sizes([1,2]),i_i,j_i))=mvar(sub2ind(sizes([1,2]),i_i,j_i))+ s_i*1i;
   end; 
case 7,  buff=str(datastartat:endstr); mvar(:)=serial2double(buff); mvar=int8(mvar);
case 8,  buff=str(datastartat:endstr); mvar(:)=serial2double(buff); mvar=int16(mvar);
case 9,  buff=str(datastartat:endstr); mvar(:)=serial2double(buff); mvar=int32(mvar); 
case 10, buff=str(datastartat:endstr); mvar(:)=serial2double(buff); mvar=uint8(mvar);
case 11, buff=str(datastartat:endstr); mvar(:)=serial2double(buff); mvar=uint16(mvar);
case 12, buff=str(datastartat:endstr); mvar(:)=serial2double(buff); mvar=uint32(mvar);
otherwise,
  error('String format invalid !!!, report error to landrade@ece.neu.edu')
end


function [a,ndsa,prec]=serial2int(str,dsa)
%function [a,ndsa,prec]=serial2int(str,dsa)

if ~ischar(str) error('str must be an array of char !'); end

if ~exist('dsa') dsa=1; end

fc=double(str(dsa));

if fc<128

  a=double(fc);
  ndsa=dsa+1;
  prec=1;
  
else
  prec=bitand(fc,112)/16+1;
  le=bitand(fc,15);nle=0;
  if le>7
    nle=le-8;
    le=sum(256.^[nle-1:-1:0]'.*str(dsa+1:dsa+nle));    
  end

  q=zeros(prec,le);
  q(:)=double(str(dsa+nle+1:dsa+nle+prec*le));
  a=sum((256.^[prec-1:-1:0]')*ones(1,le).*q,1)';
  
  ndsa=dsa+nle+prec*le+1;
end
