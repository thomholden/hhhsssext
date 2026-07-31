function []=PlotIndicatorTest(h, data, label)

% Copyright 2013 The MathWorks, Inc.

lookbackWindow=[6:3:15];
plot(h,data);
legend([num2str(lookbackWindow');'BH']);
legend('Location','NorthWest');
title(['Indicator: ' label]);

end