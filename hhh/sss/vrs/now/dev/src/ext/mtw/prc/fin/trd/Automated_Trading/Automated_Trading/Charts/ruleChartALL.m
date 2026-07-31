function ruleChartALL(prices, sh, s, r)
%RULECHARTALL Shows the performance of the combined model, after it has
% been calibrated with evolutionary learning.

% Copyright 2010-2012, The MathWorks, Inc.

figure
ax(1) = subplot(2,1,1);
plot(prices(:,end))
title(['Evolutionary Learning Results, Sharpe Ratio = ',num2str(sh,3)])
ylabel('Price (USD)')


ax(2) = subplot(2,1,2);
plot([s,cumsum(r)])
ylabel('Price (USD)')
xlabel('Serial time number')

legend('Position','Cumulative Return', 'Location', 'best')

title(['Final Return = ',num2str(sum(r),3), ...
    ' (',num2str(sum(r)/prices(1,end)*100,3),'%)'])
linkaxes(ax,'x');
axis tight