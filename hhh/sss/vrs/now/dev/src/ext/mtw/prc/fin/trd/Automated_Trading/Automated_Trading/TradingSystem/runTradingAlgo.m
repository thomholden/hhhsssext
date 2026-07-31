function rs = runTradingAlgo()
% Copyright 2010-2012, The MathWorks, Inc.

%% Make sure we have a queue
q = createMSMQ(); %#ok<NASGU>

%% Start the FIX Execution Engine
system('C:\sandbox\java\quickfixj\bin\executor.bat&')

%% Open up our 1st receiving application, in this case an Excel workbook.
winopen('orderHistory.xlsm')

%% Open up the 2nd receiving application, Banzai
startBanzai('banzai.cfg');

%% Start Reuters Playback Engine
% Change the following line of code to the folder that contains the Reuters
% Playback engine (specifically, the folder that contains "playback.exe").
enginePath  = 'C:\MATLAB\Tools\ReutersPlayback';
configFile  = 'config_file_brent.txt';

system(['cd ' enginePath ' & playback ' configFile ' &']);

%% Connect and fetch data
% Connect to Reuters and pass our data to the generateTrade function in
% realtime.
rs = reuters('myNS::remoteSession', 'IDN_RDF');
fetch(rs, 'BRENT', 'tradingSystem')

