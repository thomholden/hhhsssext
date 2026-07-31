function imageData = getPricesPlot(prices, stockNames, imageWidth, imageHeight)
% generates a plot of the prices and takes a snapshot of it.

if nargin < 3
    imageWidth = 485;
    imageHeight = 360;
end

imageData = [];
if ~(isempty(prices))
    f = figure;
    set(f, 'Visible', 'off');
    set(f, 'Position', [0, 0, imageWidth, imageHeight]);
    %set the colour to white
    set(f, 'Color', [1 1 1])
    plot(prices);
    ylabel('Price');
    
    if ~(isempty(stockNames))
        legend(stockNames, 'Location', 'NorthEastOutside');
    end
    
    imageData = getBitmap(f);
    close(f)
end