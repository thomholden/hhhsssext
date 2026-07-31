function [date, close, open, low, high, volume, closeadj] = StockQuoteQuery(symbol, start_date, end_date, frequency, varargin)


% Initialize input variables to empty matrices
echo off
dates = cell(1); date = [];
open = []; high = []; low = []; close = []; closeadj = [];
volume= [];
stockdata = {}; %Cell array for holding data lines from query

matlabv= str2num(version('-release'));
connect_query_data=0;  %this variable holds the status of the query steps;

verbose=0;
if ( nargin < 4 ),
    error('Not enough inputs');
elseif ( nargin >= 5 );
    v5=varargin{1};
    if isnumeric(v5), verbose=v5; end;
    if ischar(v5) & strncmp(upper(v5),'VERBOSE',1), verbose=1; end;
end;

symbol=upper(symbol);

% Set up the dates and query string
date1=datenum(start_date);   date2=datenum(end_date);
if date1 > date2; %switch dates;
    date1= date2;
    date2= datenum(start_date);
end;  
urlString = YahooUrlString(symbol, date1, date2, frequency);


% Prepare to query the server by opening the URL and using the 
% Java URL class to establish the connection.

if (verbose>=1);
    disp('Contacting YAHOO server using ...');
    disp(['url = java.net.URL(' urlString ')']);
end;
url = java.net.URL(urlString);


try
    stream = openStream(url);
    ireader = java.io.InputStreamReader(stream);
    breader = java.io.BufferedReader(ireader);
    connect_query_data= 1; %connect made;
catch
    connect_query_data= -1;  %could not connect case;
    disp(['URL: ' urlString]);
    error(['Could not connect to server. It may be unavailable. Try again later.']);
    stockdata={};
    return;
end

if (verbose>=1);
    disp(['Reading data for symbol ' symbol '...']);
end;

% First line has column header labels
line = readLine(breader);
if (verbose>=1);
    disp('Header Line');
    disp(breader);
    disp ' '
end;
    
    
    not_done=1;
    ii=0;

    while not_done
        
        if (isempty(line) | prod(size(line)) == 0 ); 
            not_done=0;
            if (verbose>=1);
                disp(['... Finished, ' num2str(ii-1) ' lines of data']); 
            end;
            if ii > 0 & ~isempty(stockdata);
                connect_query_data = 2; %query processed;
            else;
                connect_query_data = -2;
            end;
            break; 
        end;
        
        ii=ii+1;  
        line = readLine(breader);
        line = char(line);
        if (verbose==2);
            disp(['Line ' num2str(ii) ': ' line]);
        end;
        
    % Add line to cell matrix if it has the full elements;
    %  try-if added to make R12 compatible
    try;
    if ( ~isempty(line) & size(line,2) > 3 & size(findstr(line,','),2) == 6 );
        line(end+1) = ','; 
        stockdata{ii} = line;
    end;
    catch; %do nothing in case of error above 
    end;
end

stockdata = cat(2,stockdata{:});

% Parse the string data into MATLAB numeric arrays. 
if (length(stockdata) > 0)    
    
    % Note that the order of -- open, high, low, close -- matches the YAHOO server table order,
    % not the function's output order of [date, close, open, low, high, volume, closeadj] 
    
    if matlabv >= 13;
      [dates, open, high, low, close, volume, closeadj] = strread(stockdata,'%s%f%f%f%f%n%f', 'delimiter', ',', 'emptyvalue', NaN);
    else; % R12 version of strread does not have 'emptyvalue' option;
      [dates, open, high, low, close, volume, closeadj] = strread(stockdata,'%s%f%f%f%f%n%f', 'delimiter', ',');
    end;
    
    % Reverse the data vectors to run oldest to most recent
    open=flipud(open); high=flipud(high);  low=flipud(low);
    close=flipud(close);  closeadj=flipud(closeadj);
    volume=flipud(volume);
    
    % Convert the string dates into date numeric format, '1-Jan-0000'=1
    date = datenum(dates);
    date=flipud(date);
    
    connect_query_data = 3; %data processed;
    
    if (verbose>=1);
        disp(['Converted stock data to dates, open, high, low, close, volume, close2']); 
        disp(['Dates: ' datestr(date(1)) ' to '   datestr(date(end)) '  ' num2str(size(close,1)) ' observations']);      
    end;
end

%end of STOCKQUOTEQUERY function


function [urlString] = YahooUrlString(symbol, start_date, end_date, freq);
% Builds the YAHOO Stock Data query string, a specially formatted URL 
%   For retrieving stock quote data from  server = 'http://table.finance.yahoo.com' 
%   This function is used by STOCKQUOTEQUERY (& SQQ) and is based on 
%   GETSTOCKDATA by Peter Webb of Mathworks 
%
% Inputs:
%   SYMBOL: String representing the stock symbol
%   START_DATE: Serial date number
%   END_DATE: Serial date number
%   FREQ: Daily ('d'), Monthly ('m'), or Weekly('w')

% Server URL (name) should not change, query parameters tagged to the end of
% server URL string will vary according to user inputs
server = 'http://table.finance.yahoo.com/table.csv';

% Set day, month and year for the start and end dates
[startYear startMonth startDay] = datevec(start_date);
[endYear endMonth endDay] = datevec(end_date);

query = ['?a=' num2str(startMonth-1) '&b=' num2str(startDay) '&c=' num2str(startYear) ...
         '&d=' num2str(endMonth-1)   '&e=' num2str(endDay)   '&f=' num2str(endYear) ...
         '&s=' num2str(symbol) '&y=0&g=' num2str(freq) ];
% note adjustment to month number - 1, January=0, December=11

% Concatenate the server name and query parameters to complete the URL+query string
urlString = [ server query ];

%end of YAHOOURLSTRING function