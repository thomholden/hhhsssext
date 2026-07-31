function DisplayStockData(symbol, startdate, frequency, periods)
% DISPLAYSTOCKDATA Plot stock prices and compare to S&P 500
%
% Query the Yahoo! historical quote server for stock price data, and generate 
% two figures: a candlestick plot (open, close, high and low prices for the 
% given period); and a comparison of the given stock with the performance of
% S&P 500 (use the USAA Index fund as a proxy for the S&P 500).
%  
% Example:
%
%   DisplayStockData('S', '1/1/2000', 'm', 27)
%
%   Plot 27 months of stock price data for Sears, starting Jan 1, 2000. 
%   Frequency can be 'y', for year, or 'd' for day.

% Get the opening price, high price, low price and closing price for the
% stock over the indicated time period
[open, high, low, close, date] = GetStockData(symbol, startdate, frequency, periods);

if (length(open) <= 0)
    disp('No stock data retrieved. Check that the server is available and the stock symbol is valid.');
    return;
end

% Compute the periodic growth rate of the closing price
rate = periodGrowth(close, frequency);

% Draw a candlestick chart
f = figure;

try
    hold on
    candle(high, low, close, open, 'red', date, 2);
    grid on
    
    t = sprintf('Stock symbol: %s, compound annual growth rate: %4.2f%', upper(symbol), rate);
    title(t, 'FontWeight', 'bold');
    hold off
catch
    disp('Candle function is not available...skipping candlestick chart.');
    delete(f);
end

% Now get the S&P 500 data (use the USAA Index fund as a proxy for this).
% Other funds could also be used: ETSPX (ETrade), PEOPX (Dreyfus), etc.
[open500, high500, low500, close500, date500] = ...
    GetStockData('USSPX', startdate, frequency, periods);

width = 3.0;
figure
hold on
grid on
line(date500, close500, 'color', 'blue', 'LineWidth', width);
line(date, close, 'color', 'red', 'LineWidth', width);
hold off
legend('S&P 500', upper(symbol), 0);
if (exist('dateaxis'))
    dateaxis('x', 12);
else
    daxis('x', 12);
end
t = sprintf('Relative Performance of %s (%2.0f%%) and S&P 500 (%2.0f%%)', upper(symbol), rate, ...
            periodGrowth(close500, frequency));
title(t, 'FontWeight', 'bold');

function rate = periodGrowth(series, frequency)
% CAGR Compute compound growth rate for the given series

fv = series(1);
pv = series(end);
n = length(series);
rate = ((fv/pv)^(1/n)) - 1;
rate = rate * 100;
if (frequency == 'd')
    rate = rate * 360;
elseif (frequency == 'm')
    rate = rate * 12;
end

