% Copyright 2013 The MathWorks, Inc.

%% Compute indices & stats
bahRtn=mean(intraperiodRtn,2);
stratRtn=mean(pickedRtns,2);
clf;
[bahStats, bahIndex, labels]=ComputeStatistics(bahRtn,'m');
[stratStats, stratIndex, ~]=ComputeStatistics(stratRtn,'m');

comp = [flipud(struct2array(bahStats)') ...
        flipud(struct2array(stratStats)')];
comp = [comp comp(:,2)-comp(:,1)];

%% Set up and draw plots
h=subplot(2,1,1);
plot(h,dates,bahIndex(2:end),'DisplayName','B&H Basket');
hold(h,'all');
plot(h,dates,stratIndex(2:end),'DisplayName','Strategy');
datetick('x','mmmyyyy','keepticks','keeplimits');
legend('toggle');
legend('Location','NorthWest');
hold off
h=subplot(2,1,2,'XTickLabel',labels, ...
                'XTick', 1:length(labels));
box(h,'on');
hold(h,'all');
bar(comp,'Parent',h);
