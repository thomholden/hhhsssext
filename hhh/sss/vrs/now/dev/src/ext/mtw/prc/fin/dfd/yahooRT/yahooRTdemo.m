%YAHOORTDEMO verifies that YAHOORT is returning real-time data by comparing the
%timestamp on data returned by YAHOO vs. YAHOORT.
%
% NOTE: There's only a difference during active trading hours! (9:30am-4pm ET)
%
% For instructions on YAHOORT, type
%     help yahooRT
% at the MATLAB command prompt.


% Must set to a valid Yahoo account subscribed to Yahoo Premium Finance.
username = '';
password = '';

y = yahoo;
r = yahooRT(username,password);

% FETCH delayed Yahoo data
dataY = fetch(y,'GM')
timeY = dataY.Date+dataY.Time;
datestr(timeY)

fprintf('\n');

% FETCH real-time Yahoo data
dataR = fetch(r,'GM')
timeR = dataR.Date+dataR.Time;
datestr(timeR)

fprintf('\n');

% Show the difference between the timestamps
fprintf('Difference between times: %s\n', datestr(timeR-timeY,'HH:MM:SS'));