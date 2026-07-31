%% Set up literals for use in data cleanup/alignment
%
% Copyright 2013 The MathWorks, Inc.
CommodityTypes = {'Energy', 'Metal', 'Grain', 'Soft', ...
    'Livestock', 'Index'};
CmdTypesShort = {'NRG','MTL','GRN','SFT','LSK','IDX'};
DataSources = {'CSV', 'Database', 'Yahoo'};
MonthContracts = [1 2 4];
FirstDay='1/1/1999';
LastDay='05/31/2013';
ColumnNames = {'Date', 'Open', 'High', 'Low', 'Close', 'Vol', 'OI'};
