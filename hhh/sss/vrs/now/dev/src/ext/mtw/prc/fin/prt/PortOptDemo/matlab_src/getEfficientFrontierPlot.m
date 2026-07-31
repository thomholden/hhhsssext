function imageData = getEfficientFrontierPlot(prisk, preturn, imageWidth, imageHeight)
% generates an efficient frontier and takes a snapshot of it

if nargin < 3
    imageWidth = 485;
    imageHeight = 360;
end

imageData = [];
if ~(isempty(prisk) || isempty(preturn) )
    f = figure;
    set(f, 'Visible', 'off')
   set(f, 'Position', [0, 0, imageWidth, imageHeight]);
    %set the colour to white
    set(f, 'Color', [1 1 1])
 
    plot(prisk, preturn);
    title('Mean-Variance Efficient Frontier')
    xlabel('Risk (Standard Deviation)');
    ylabel('Expected Return');
    
    imageData = getBitmap(f);
    close(f)
end