function [handle ] = PlotAllCommodities(source, handle)
%PLOTALLCOMMODITIES Plot all commodities in a data container.
%   source          Name of source container
%   handle          (Optional) Subplot handle to plot at
% We assume that each of the datasets in the container has data beginning
% from the same point in time.
% We will only plot the front month contracts, such as CL.1, GC.1, etc.

% Copyright 2013 The MathWorks, Inc.

if (nargin<2)
    figure;
    currAxes=gca;
else
    currAxes=handle;
end

% Go through all the commodities in the container
symbols = fields(source);
    
for i = 1:length(symbols)
    currSym = source.(symbols{i});
    currName = currSym.Metadata.Commodity{1};
    
    % Get the front month data
    dataSet=currSym.Month{1};
    dates=dataSet.Date;
    rtnSeries=dataSet.Close / dataSet.Close(1);
    plotHandle=plot(currAxes,dates,rtnSeries);
    set(plotHandle,'DisplayName',currName);
    hold all;
end

grid on;
legend('toggle');
legend('Location', 'NorthWest');
hold off;
dynamicDateTicks;
% datetick('x','mmmyyyy','keepticks','keeplimits');

end

