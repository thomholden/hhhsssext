function worker(majordomo)
%function worker(majordomo)
% By Lucio Andrade, Feb 2001

magic_port=5321;
hostname=getmyip;
func.name='';

disp('Checking if majordomo is alive')

while ~strcmp(func.name,'release')
  
  ip_fid=-1; 
  while ip_fid<0 
     ip_fid=tcpip_open(majordomo,magic_port);
  end

  sendvar(ip_fid,hostname)  %tells majordomo I'm ready !!!
  
  disp('Waiting instructions from majordomo ...')

  func.name=getvar(ip_fid);
  func.argin=double(getvar(ip_fid));
  func.argout=double(getvar(ip_fid));
  
  if ~strcmp(func.name,'release')
  
    %%%% BUILD THE COMMAND STRING
    command='';
    if func.argout command='[argo1'; end
    for i=2:func.argout command=[command ',argo' int2str(i)]; end
    if func.argout command=[command ']=']; end
    command=[command func.name '(argi1'];
    for i=2:func.argin command=[command ',argi' int2str(i)]; end
    command=[command ');'];
    disp(command)
    disp('Reading input arguments')
  
    %%%% READ IN ARGUMENTS
    for i=1:func.argin
      tmp=getvar(ip_fid);
      if ~isempty(tmp) eval(['argi' int2str(i) '=tmp;']);
      else disp(['Recycling argi' int2str(i)]);
      end
    end

    tcpip_close(ip_fid);
  
    disp('Processing......')
    
    therewasanerror=0;
    try
       eval(command);
    catch
       %starts error handling rutine
       disp([' Error ==> ' lasterr])
       disp([' I''ll notify majordomo and wait for instructions.'])
       ip_fid=tcpip_open(majordomo,magic_port+1);
       sendvar(ip_fid,hostname)
       sendvar(ip_fid,[])      %this will indicate to receive task that there was an error
       sendvar(ip_fid,lasterr) %now send the error
       errhan=getvar(ip_fid);  %now I wait for instruction on what to do
       tcpip_close(ip_fid)
       if errhan 
          disp([' OK, I''ll let you debug my workspace,']) 
          disp([' type ''dbcont'' to resume worker'])
          dbstop worker 65; 



 
       end 
       therewasanerror=1;
    end %tru-catch
       
    if ~therewasanerror  % can continue with normal procedure    
       
       ip_fid=tcpip_open(majordomo,magic_port+1);
      
       %%%% SEND ARGUMENTS
  
       disp('Sending output arguments')
    
       sendvar(ip_fid,hostname)
    
       for i=1:func.argout
          eval(['sendvar(ip_fid,argo' int2str(i) ')'])
       end
    
       %%%% wait to make sure majordomo read my results
       disp('Waiting for ack')
       ack=getvar(ip_fid);

       tcpip_close(ip_fid)
    end %~therewasanerro 
  
  end %~strcmp(func.name,'release')
end