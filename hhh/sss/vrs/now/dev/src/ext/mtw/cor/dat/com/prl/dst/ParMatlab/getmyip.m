function ipa=getmyip

if strcmp(computer,'PCWIN')
  [s,m]=unix('ipconfig');
  h=find((m>=65)&(m<=90));
  m(h)=m(h)+32;
  h=findstr(m,'ip address');
  if isempty(h) h=findstr(m,'direcc'); end %try another lang
  m(1:(h+10))=[];
  m(1:min(find((m>=48)&(m<=57)))-1)=[];
  ipa=m(1:min(find(xor((m<48)|(m>57),m==46)))-1);
elseif isunix
   [s m]=unix('hostname'); 
   [s m]=unix(['nslookup ' m]);
   h=find((m>=65)&(m<=90));
   m(h)=m(h)+32;
   m(1:findstr(m,'name:')+5)=[];
   m(1:findstr(m,'address:')+8)=[];
   m(1:min(find((m>=48)&(m<=57)))-1)=[];
   ipa=m(1:min(find(xor((m<48)|(m>57),m==46)))-1);
else
   error(' Don''t know how to detect your IP address. Please adjust getmyip.m for your OS');
end 


% check output is a valid ip address
h=find(ipa=='.');
if length(h)~=3 ;  %ip must have 3 points !
  error(' Don''t know how to detect your IP address. Please adjust getmyip.m for your OS');
end
ipat=ipa;ipat(h)=[];
if ~prod((ipat>=48)&(ipat<=57))  %remaining chars must be digits ! 
  error(' Don''t know how to detect your IP address. Please adjust getmyip.m for your OS');
end