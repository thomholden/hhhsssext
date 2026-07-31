% Two days ago, on MATLAB Central, I found Greggory asking something about 
% "urlread" which is lack of TIMEOUT capability. And such a deficiency 
% often leads to an embarrassing and horriable situation that main function 
% gets freezed easily when the network is busy or abnormal. 
% At the beginning, I tried to follow the asker by using a timer, but it 
% failed finally. The reason I thought is that timer can not interrupt the 
% task being busy at all and yet MATLAB doesn't have a scheme for using 
% multi-threads so far. Fortunately, I discovered another hope that a part 
% of urlread is written in JAVA. So I tried to modify the urlread function 
% by adding a "timeout" parameter, enabling it to automatically stop the 
% request at a time the user specified.

% (1) urlread.m  -> urlread2.m
% (2) urlwrite.m -> urlwrite2.m

% A simple example
ex1 