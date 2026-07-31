function closemajordomo(sendsoc,receivesoc)

%function closemajordomo(sendsoc,receivesoc)
%
%This funtion closes the ports opened with initmajordomo,
%but first releases any remote worker that could be 
%available in the input queues
%
% by Lucio Andrade

 con=tcpip_listen(receivesoc);
 while con>-1
  ack=1;
  sendvar(con,ack)
  con=tcpip_listen(receivesoc);
 end
 
 pause(2) % to ensure workers are available
 
 con=tcpip_listen(sendsoc);
 while con>-1
  func.name='release';
  func.argin=0;func.argout=0;
  sendvar(con,func.name)
  sendvar(con,char(func.argin))
  sendvar(con,char(func.argout))
  con=tcpip_listen(sendsoc);
 end
  
 pause(2) % to ensure workers were released before braking the pipe

 tcpip_close('all')