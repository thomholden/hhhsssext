% Example Script for GetTickersData
%
% This script will get, from yahoo, trading data for the stocks  based on the
% file example_tickers.txt and then save it in a preformated excel file.
%
% You may want to change the strings at that txt file for your own assets.

clear;

%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

firstDay='01/01/2000';  % First day in sample to be downloaded (format: dd/mm/yyyy)
lastDay ='01/01/2007';  % Last day in sample to be downloaded (format: dd/mm/yyyy)

n_stocks=10;     % Number of stocks to download data (according to tickers.txt)
Criteria=.05;    % Percent of missing prices for bad data event
Freq='d';        % Frequency ('d'-dailly ; 'w' - Weekly, 'm' - monthly)

ticker_fileName='example_tickers.txt';  % file with the tickers 
fileName='testXls.xls';                 % name of excel file to save the data
benchTicker='^GSPC';                    % The benchmark asset used to compare all dates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('m_Files');         % adding both paths to matlab's search path
addpath('m_Files\sqq_msp');

[SPData]=GetTickersData(firstDay, ...
                        lastDay , ...
                        n_stocks, ... 
                        ticker_fileName, ... 
                        Freq, ... 
                        Criteria, ...
                        benchTicker);

copyDataXls(SPData,fileName);
winopen(fileName);  % opening file 


rmpath('m_Files');
rmpath('m_Files\sqq_msp');