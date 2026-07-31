function res = download_hist_yahoo_data(stock_symbol, startDate, endDate)
% 
% fetch historic data from yahoo finance between startDate and endDate.
% returns a structure with data fields.
% example: res = download_hist_yahoo_data('SPY','01-jan-2010', date)

[sYear, sMonth, sDay, tmp, tmp] = datevec(startDate);
[eYear, eMonth, eDay, tmp, tmp] = datevec(endDate);

fprintf('Please be patient; Downloading data for: %s ...', stock_symbol)

url_string = sprintf('http://ichart.finance.yahoo.com/table.csv?s=%s&a=%i&b=%i&c=%i&d=%i&e=%i&f=%i',...
    upper(stock_symbol), sMonth-1, sDay, sYear, eMonth-1,eDay, eYear);


data = urlread(url_string); % load csv data

i = regexp(data,'\n','once'); % skip header line
raw = textscan(data(i+1:end), '%s %n %n %n %n %n %n','delimiter',','); % parse data


res.dates = flipud(datenum(raw{1}));
res.open = flipud(raw{2});
res.high = flipud(raw{3});
res.low = flipud(raw{4});
res.close = flipud(raw{5});
res.volume = flipud(raw{6});
res.adj_close = flipud(raw{7});

fprintf('got %i days of data\n', length(res.dates));

%res = fints(dates, [open, high, low,close,volume,adj_close],...
%    {'open','high','low','close','volume','adj_close'},'daily',stock_symbol);
