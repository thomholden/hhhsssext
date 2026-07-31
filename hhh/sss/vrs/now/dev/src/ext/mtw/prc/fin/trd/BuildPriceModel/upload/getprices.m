function price=getprices(coinName,startdate,stopdate,granularity)
%https://docs.pro.coinbase.com/#get-historic-rates
%all cryptocurrency products returned in USD
org_url='https://api.pro.coinbase.com/products/';
product = strcat(coinName,'-USD');
% t=datetime('now','Format','uuuu-MM-dd''T''HH:mm:ss''Z');
startdate=char(startdate);
stopdate = char(stopdate);
%granularity is in seconds, so we are getting 1-minute candle: The granularity field must be one of the following values: {60, 300, 900, 3600, 21600, 86400}.
% Otherwise, your request will be rejected.
% granularity = period;
%Returns back: [time, low, high, open, close, volume];
%https://api.pro.coinbase.com/products/BTC-USD/candles?start=2015-01-01T00:00:00Z&end=2015-01-08T00:00:00Z&granularity=3600
url=strcat(org_url,product,'/candles?start=',startdate,'&end=',stopdate,'&granularity=',num2str(granularity));
% url=strcat(org_url,product,'/candles?start=',startdate,'&end=',stopDate,'&granularity=',granularity);
variables = {'Time', 'Low', 'High', 'Open', 'Close', 'Volume'};
Data=webread(url);
if isempty(Data)
    price = Data;
else
    price=array2table(Data,'VariableNames',variables);
    price.Time=datetime(price.Time,'ConvertFrom','posixtime');
end