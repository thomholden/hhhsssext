function [con,hostname,var1,var2,var3,var4,var5,var6]=receivetask(socket,funcargout,errhan)
%function [con,hostname,var1,var2,var3,var4,var5,var6]=receivetask(socket,funcargout,errhan)
%
% Receives a task which is waiting in the queue of the 'finished tasks' port
%
% INPUTS:
%
% socket     --> The port used to receive tasks (see initmajordomo)
% funcargout --> Number of output arguments that are expected
% errhan     --> (optional) is used to indicate the worker what to do in case of error
%                errhan = 0 ignore and continue (default) 
%                         1 stop remote machine to debug workspace
%                         2 stop manager and ask
%
% OUTPUTS:
%
% con        --> socket used for comm, its value is -1 if there wasn't any task finished
%                (in the future this field will return also a task id)
% hostname   --> ip address of the machine which is returning values
% var1 .. var5 --> output variables (depending on funcargout)
%                  if error occured it will return empty variables
%
%
% By Lucio Andrade, Feb 2001


if exist('errhan')~=1 errhan=0; end
   
var1=[];var2=[];var3=[];var4=[];var5=[];var6=[];
hostname=' ';
con=tcpip_listen(socket);

if con<0
  %disp('There is no data available now ...')
else
  hostname=getvar(con);
  var1=getvar(con);  %receives the first variable
  if isempty(var1)   %there was an error in the remote machine !!!!!
     disp([' ERROR in remote machine ==> ' getvar(con)])
     if (errhan==2)  %error ocurred, do we need to ask for an action ?
        disp(' Select action for remote machine:')
        disp('     [0] ignore and continue as a worker')
        disp('     [1] stop worker and debug workspace')
        errgo=input(' ==> ');
     else
        errgo=errhan;
     end
     sendvar(con,errgo) %tell the worker what to do
     var1=[]; %empty 'cuase we will return only empty variables
  else % No error, continue getting return variables
     if (funcargout>=2) var2=getvar(con); end;
     if (funcargout>=3) var3=getvar(con); end;
     if (funcargout>=4) var4=getvar(con); end;
     if (funcargout>=5) var5=getvar(con); end;
     ack=1; %send aknowlage
     sendvar(con,char(ack))
  end %isempty(var1)
  tcpip_close(con)
end