% Function for downloading and parsing google trends data
%
% INPUT:    myStr - String to download search volume (e.g. Carnival)
%           myGeo - Location of search volume (geo codes can be found at
%           google trends website)
%           chromePath - Full path of chrome.exe
%           dlFolder - Full path of chrome default download location
%
% OUTPUT:   DataOut - Structure with dates and gtrends data
%
% AUTHOR: Marcelo Perlin (marcelo.perlin@ufrgs.br)

function [DataOut]=GetGtrendsData(myStr,myGeo,chromePath,dlFolder)

% error checking

% check internet

url = 'http://www.mathworks.com/products/matlab/';
[~,flag] = urlread(url);

if flag==0
    error('Error in checking internet connection. You should connect to the internet while using this function')
end

if ~exist(chromePath,'file')
  %20  error('Chrome.exe path is not correct. Check google for correct path');
end

if ~exist(dlFolder,'dir')
    error('The download folder is not correct. Check chrome settings');
end

% change all white spaces in string

myStr = regexprep(myStr, ' ', '%20');

% delete report.csv at download folder
pathReport_csv=[dlFolder 'report.csv'];

if exist(pathReport_csv,'file')
delete(pathReport_csv);
end

if exist([dlFolder 'report.csv'],'file')
    error(['There is a file report.csv at ' dlFolder '. You must manually delete it']);
end

chromePath=['"' chromePath '"'];

fileOutGtrends=[dlFolder 'report.csv'];

link='http://www.google.com.br/trends/TrendsRepport?q=';
link=[link myStr '&geo='];
link=[link myGeo];
link=[link '&content=1&export=1&graph=all_csv'];

str=['!' chromePath ' ' link];
eval(str);

% wait a couple second before next access to gtrends (this prevents google
% blocking you)

pause(randi(3));

while 1 % wait for download to appear in folder
    if exist(pathReport_csv,'file')
        break
    end
end

[startDate,endDate,typeDate,gtrendsOut] = ReadGtrendsData(fileOutGtrends);

DataOut.startDate=startDate;
DataOut.endDate=endDate;
DataOut.typeDate=typeDate;
DataOut.gtrendsOut=gtrendsOut;

