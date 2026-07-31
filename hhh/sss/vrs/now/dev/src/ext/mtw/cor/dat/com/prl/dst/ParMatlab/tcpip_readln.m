function str=tcpip_readln(fid,len)
  
% str=tcpip_readln(fid,len)
%
% fid   is file id.
% len   is maximum length to be read.
%
% Reads a line of charters terminated by newline character (LF).
% If the a full line (until LF) isn available at the
% moment a empty string will be returned.
% CR and LF characters will not be returned in the string.
%
  str=tcpipmex(4,fid,len);
  
  if(length(str))
    str=str(find(str~=10 & str~=13)); % Remove all 10 & 13
  end
  return;
  
  
  
  
  
  
  
  
  
  
  
  

