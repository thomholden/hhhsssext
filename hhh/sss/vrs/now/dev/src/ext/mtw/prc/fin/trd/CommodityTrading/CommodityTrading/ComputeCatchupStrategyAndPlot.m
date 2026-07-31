% Copyright 2013 The MathWorks, Inc.

params = struct;
params.LookbackWindow=lookbackWindow;
params.Indicator=indicatorFcn;
params.HowMany=1;
params.SkipPeriod=2;
params.TxnCost=20/10000;
frequency='m';

%% 3. Loop through commodity sectors, generate stats
cagrSet=[];sortinoSet=[];sharpeSet=[];drawdownSet=[];
rtnSet=[];bahSet=[];
for i=1:(length(CommodityTypes)-1)
    container = selectedContainer;
    container = FilterByType(container,CommodityTypes{i});
    params.DataContainer = container;
    params.ContractMonth = 1;
    [sectorRtn, bahRtn] = ComputeCrossSectionalMomentum...
        (params);

    rtnSet = [rtnSet sectorRtn];
    bahSet = [bahSet bahRtn];
    GetAllStatistics;
end

%% 4. Plot B&H performance with strategy performance
[bahStats, bahIndex, labels] = ComputeStatistics(mean(bahSet,2),'m');
[stratStats, stratIndex, ~] = ComputeStatistics(mean(rtnSet,2),'m');

comp = [flipud(struct2array(bahStats)') ...
        flipud(struct2array(stratStats)')];
comp = [comp comp(:,2)-comp(:,1)];  

clf;
h=subplot(2,1,1);
plot(bahIndex,'DisplayName','B&H');hold all;
plot(stratIndex,'DisplayName','Strategy');
legend('toggle');
legend('Location','NorthWest');
title(sprintf('Backtest CAGRs - Strategy: %3.2f%%, B&H: %3.2f%%', ...
      cagr(stratIndex,12)*100,cagr(bahIndex,12)*100));
hold off;
h=subplot(2,1,2,'XTickLabel',labels,'XTick',1:length(labels));
box(h,'on');
hold(h,'all');
bar(comp,'Parent',h);



