function [con,hostname]=sendtask(sendsoc,funcname,funcargin,funcargout,var1,var2,var3,var4,var5,var6)
%function [con,hostname]=sendtask(sendsoc,funcname,funcargin,funcargout,var1,var2,var3,var4,var5,var6)
%
% Sends a taks to a machine which is waiting in the queue of the 'remote machines available' port
%
% INPUTS:
%
% sendsoc    --> The port used to send tasks (see initmajordomo)
% funcname   --> string with the name of the funtion to implement
% funcargin  --> Number of input arguments 
% funcargout --> Number of output arguments that are expected
% var1 .. var5 --> input variables (depending on funcargin)
%
% OUTPUTS:
%
% con        --> socket used for comm, its value is -1 fi there wasn't any remote finished
%                machine ready to use (in the future this field will return also a task id)
% hostname   --> ip address of the machine which will process the task
%
% By Lucio Andrade, Feb 2001

func.name=funcname;
func.argin=funcargin;
func.argout=funcargout;

hostname=' ';
con=tcpip_listen(sendsoc);

if con<0
  %disp('There is no worker available now ...')
else
  
  hostname=getvar(con);
  
  %disp(['Sending task to ' hostname ])

  sendvar(con,func.name)
  sendvar(con,char(func.argin))
  sendvar(con,char(func.argout))
  for i=1:func.argin
      eval(['sendvar(con,var' num2str(i) ');'])
  end

  tcpip_close(con);
end
