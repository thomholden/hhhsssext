function [stockNames, meanRets, stdRets, covMat, plotImage] = readStockDataFromFile(filename)
%
%Reads stock data from an Excel file.  The file contain dates in the first
%column and the names of the stocks in the first row.
%


if ~ischar(filename)
    error('readDataFromFile: Invalid filename specified');
end

stockNames = [];
prices = [];
meanRets = [];
stdRets = [];
covMat = [];
plotImage = [];

if strfind(filename, '.xls')
    [prices, text] = xlsread(filename);
    %assume that the data is in a fixed format. ie. dates in first column,
    %stock names along the first row
    stockNames = text(1, 2:end);
    
    if ~isempty(prices)
        returns = prices(2:end, :) ./ prices(1:end-1, :) - 1;
        meanRets = mean(returns, 1);
        stdRets = std(returns, 0, 1);
        covMat = cov(returns);
    end
    
    if nargout == 5
        plotImage = getPricesPlot(prices, stockNames);
    end
end

