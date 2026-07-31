% Script for Gtrends and Matlab
%
% This code has been tested in windows 7/8.
%
% INSTRUCTIONS
% 1) Verify your chrome.exe file path (google can help you) and copy it over 
% to chromePath (see script)
% 2) Manually open one chrome brownser and leave it open dring the whole process 
% 3) In chrome, change the download settings so that all downloads go to your default download folder without user dialog
% 4) Set your default download path in dlFolder (see script)
% 5) Run this script

clear;clc;

addpath('mFiles');

myStr='Carnaval';
myGeo='BR'; % you can find other geo at google trends website

chromePath='C:\Program Files (x86)\Google\Chrome\Application\Chrome.exe';
dlFolder=['C:\Users\' getenv('USERNAME') '\Downloads\']; % this should work for windows

% call function to download from gtrends

[DataOut]=GetGtrendsData(myStr,myGeo,chromePath,dlFolder);

% make a nice plot

plot(datenum(DataOut.startDate,'yyyy-mm-dd'),DataOut.gtrendsOut);
datetick('x','yyyy-mm');
title(['Gtrends Result for ' myStr ' at ' myGeo]);

rmpath('mFiles');