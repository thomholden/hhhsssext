function var=getvar(ip_fid)
%function var=getvar(ip_fid) 
%
%  ip_fid    Handler id for tcpip channel.
%  var       Variable to return
 

 if nargin~=1
   error('Wrong number of input arg')
 end
 prec=[];
 while isempty(prec)
  prec=double(tcpipmex(3,ip_fid,1));
 end
 
 if prec
 
   buflenstr=[];toread=prec;
   while toread
     received=tcpipmex(3,ip_fid,toread);
     toread=toread-length(received);
     buflenstr=[buflenstr received];
   end  
   index=1;toread=sum(256.^([prec-1:-1:0]).*buflenstr);buff(toread)=' ';
   while toread
     received=tcpipmex(3,ip_fid,toread) ;
     lenrec=length(received);
     buff(index:index+lenrec-1)=received;
     toread=toread-lenrec;
     index=index+lenrec;
   end
   var=str2mvar(buff);
 
 else
   var=tcpip_getvar(ip_fid);
 end