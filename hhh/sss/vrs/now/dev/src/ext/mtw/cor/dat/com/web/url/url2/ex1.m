clc;
urltxt = 'http://newsreader.mathworks.com/WebX?14@505.cHZwaAFF6Le.0@.ef13b7c';
t1 = 5000;     % (1) It's 5 seconds and it's adequate for urlread2 to get data
try
  txt1 = urlread2(urltxt, [], [], t1);
  disp('t1, successful'); 
catch
  disp('t1 failed');     
end

%==========================================================================
t2 = 5;        % (2) It's 0.005 seconds and it's too short to get data successfully
try 
  txt2 = urlread2(urltxt, [], [],t2);
  disp('t2, successful'); 
catch
  disp('t2, failed');      
end

