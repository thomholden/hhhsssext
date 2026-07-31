function ret=sendvar(ip_fid,var)
%
%  ret = sendvar(ip_fid,var)
%
%  ip_fid    Handler id for tcpip channel.
%  var       Variable to send
%  ret       Return value.

%if strcmp(class(var),'char') | strcmp(class(var),'double') | strcmp(class(var),'struct') | strcmp(class(var),'cell')  | strcmp(class(var),'sparse')

if ~isobject(var)
 [buff,bufflen]=mvar2str(var);
 q=dec2hex(bufflen);
 q=[dec2hex(zeros(size(q,1),rem(size(q,2),2))) q]; %refill to have bytes
 prec=char(size(q,2)/2);
 buflenstr=char(hex2dec(reshape(q',2,prec)'));
 tcpipmex(2,ip_fid,prec);
 tcpipmex(2,ip_fid,buflenstr);
 tcpipmex(2,ip_fid,buff);
 
else %I do not handle this type of variable, then I use Pete's toolbox, may be slower and will not
   %work cross-plattaforms
   
   error('Can not handle objects in this toolbox, try to send structs instead ! ');
   
 %tcpipmex(2,ip_fid,char(0));
 %tcpip_sendvar(ip_fid,var);
 
end
 