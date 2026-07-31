function []=PlotPerf(h,cmdTypes,data,ylab,plotTitle)

% Copyright 2013 The MathWorks, Inc.

range=1:(length(cmdTypes)-1);
set(gca,'XTickLabel',cmdTypes(range), ...
    'XTick',range);
hold(h,'all');
box(h,'on');
bar(data,'Parent',h);
ylabel(ylab);
title(gca,plotTitle);

end