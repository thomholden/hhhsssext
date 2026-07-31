function [ allIndices, idxBAH ] = ComputeCrossSectionalStrategy( CommodityTypes, mainContainer, indicatorFcn, lookbackWindow)

% Copyright 2013 The MathWorks, Inc.

%% Set up constant parameters
params=struct;
params.HowMany=1;
params.SkipPeriod=2;
params.TxnCost=20/10000;
    
allIndices=[];

% Loop through commodity sectors
for j=1:numel(lookbackWindow)
    rtnSet=[];bahSet=[];    
    
    for i=1:(numel(CommodityTypes)-1)
        container = mainContainer;
        container = FilterByType(container,CommodityTypes{i});
        params.DataContainer = container;
        params.ContractMonth = 1;
        params.Indicator = indicatorFcn;
        params.LookbackWindow = lookbackWindow(j);
        [sectorRtn, bahRtn] = ComputeCrossSectionalMomentum(params);
        rtnSet = [rtnSet sectorRtn];
        bahSet = [bahSet bahRtn];
    end

    % Compute B&H and strategy indices
    idxBAH = ret2tick(mean(bahSet,2),100);
    idxStrategy = ret2tick(mean(rtnSet,2),100);
    
    allIndices = [allIndices idxStrategy];
end
    
end

