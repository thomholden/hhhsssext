function no_ip(hostname,usr,pass)
% API for NO-IP Dynamic DNS update
% This sctipt checks external Ip address and register with No-ip servers 
% Reference: http://www.noip.com/integrate/request%
% Note: Update the string listed in user credentials
%
%
% Usage instructions
% no_ip('mysite.no-ip.org','myusername','mypassword')
%

%Obtaining external IP address
url = 'http://checkip.dyndns.org';
fprintf('\nPinging to %s \nPlease Wait....\n',url);
str2=urlread(url);
ip=regexp(str2,'(\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3})','match');

%User credentials from function arguments

% Passing values to no-ip server
myip=ip{:}; 
URL='http://dynupdate.no-ip.com/nic/update';
fprintf('Yout Current IP address %s\n\n',myip)
fprintf('Submiting values to %s\nPlease wait..\n\n',URL)
[msg status] =urlread(URL,'Get',{'hostname',hostname,'myip',myip},'Authentication','Basic','Username',usr,'Password',pass,'UserAgent','Mozilla/5.0 (X11; Linux x86_64)');
if (status==0)
fprintf('Error occurred\nRetry later\n') ;
else
fprintf('Message from No-IP server = %s \n\nProcess completed.\n',msg)
end
% Note 1: 'nochg' means either your current ip address is already updated  or login details are wrong.
% Note 2:  'Authentication','Basic' refers to  base64 encoding