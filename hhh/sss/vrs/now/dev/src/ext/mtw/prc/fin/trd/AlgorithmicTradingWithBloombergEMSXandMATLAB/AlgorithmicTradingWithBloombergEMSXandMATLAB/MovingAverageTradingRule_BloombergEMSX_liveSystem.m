%% Algorithmic Trading with MATLAB and Bloomberg EMSX: Online System
% This demo uses our simple intraday moving average strategy to develop a
% trading system. Based on historical and current data, the decision engine
% decides whether or not to trade, and sends orders to the desktop trade
% executation system in real time. The desktop trade execution system is
% Bloomberg EMSX. We will use Bloomberg API's test server and one of their
% dummy broker's, BB.

% This script is based on the code from the webinars "Algorithmic Trading
% with MATLAB - 2010", and "Automated Trading with MATLAB - 2012", by
% Stuart Kozola.

% Copyright (c) 2010-2012, The MathWorks, Inc.
% All rights reserved.

% Author: Nicole Wilson, OPTI-NUM solutions, October 2013
% Please email nicole@optinum.co.za with any comments

%% Pre-Trading Tasks
%%
% *Add BLPAPI3.jar to java class path*
% javaaddpath('C:\blp\API\blpapi3.jar')

%%
% *Connect to Bloomberg V3 Communications Server*
% For the data
b = blp;
%%
% *Connect to the EMSX API Production Server*
% c = emsx('//blp/emapisvc');
%
% *Connect to EMSX API Test Server*
% This creates a Bloomberg EMSX connection object.
c = emsx('//blp/emapisvc_beta');

%% Fetch equity data from Bloomberg BLP datafeed

equity = 'SBK'; % Ticker symbol for equity around which we will develop the strategy. This can be changed.

startTime = today;
endTime = now;
annualScaling = sqrt(250*7*60);

Ticker = strcat(equity,' Equity');

% Get raw tick data:
todaysData = timeseries(b,Ticker,{startTime,endTime}); % gives back trade, time stamp, price, quantity

todaysTimes = cell2mat(todaysData(:,2));
todaysPrices = cell2mat(todaysData(:,3));

%% Execute strategy

% Parameters:
lagParam = 66;
leadParam = 43;

%%
% First Trade

currentPrices = todaysPrices(end-(lagParam - 1):end);
currentTimes = todaysTimes(end-(lagParam - 1):end);

signal = constructTradingSignal(currentPrices,leadParam,lagParam);

if signal ~= 0
    executeTrades(c, equity, signal)
end

%%
% Go for 5 minutes
presentTime = now;
initialTime = presentTime;

while presentTime <= initialTime + 5/60/24;
    newData = timeseries(b,Ticker,{endTime,presentTime}); % get raw tick data between now and endTime
    
    newPrices = [currentPrices; cell2mat(todaysData(:,3))];% append to previous data
    newTimes = [currentTimes; cell2mat(todaysData(:,2))];
    
    signal = constructTradingSignal(currentPrices,leadParam,lagParam);
    
    if signal ~= 0
        executeTrades(c, equity, signal)
    end
    
    % update times
    endtTime = presentTime;
    presentTime = now;
end




