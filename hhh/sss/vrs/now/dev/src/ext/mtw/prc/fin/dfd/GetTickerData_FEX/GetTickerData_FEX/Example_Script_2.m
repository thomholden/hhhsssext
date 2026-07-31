% This Example script will first dowload today's composition of SP500 and
% then download the data to you matlab desktop using yahoo server.
%
% Notes that the up to date tickers will be stored at the ticker_fileName
% text file

clear;

%%%%%%%%%%%%%%%%%%%%%%% OPTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

firstDay='01/01/2000';  % First day in sample to be downloaded (format: dd/mm/yyyy)
lastDay ='01/01/2007';  % Last day in sample to be downloaded (format: dd/mm/yyyy)

n_stocks=10;            % Number of stocks to download data (according to tickers.txt)
Criteria=.05;           % Percent of missing prices for bad data event
Freq='d';               % Frequency ('d'-dailly ; 'w' - Weekly, 'm' - monthly)

ticker_fileName='SP500_comp.txt'; % the name of txt file where the updated composition will be saved
benchTicker='^GSPC';              % The benchmark asset used to compare all dates

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('m_Files');             % adding both paths to matlab's search path
addpath('m_Files\sqq_msp');

SP500_to_txt(500,ticker_fileName);  % function that saves the most updated SP 500 compositions in a txt file

[SPData]=GetTickersData(firstDay, ...
                        lastDay , ...
                        n_stocks, ... 
                        ticker_fileName, ... 
                        Freq, ... 
                        Criteria, ...
                        benchTicker);
                      
                      
rmpath('m_Files');                           
rmpath('m_Files\sqq_msp');