% Copyright 2013 The MathWorks, Inc.

for j = 1:numel(MonthContracts)
    currContract = MonthContracts(j);
    CSVfile = ['.\Datasets\' symbol int2str(currContract) '.csv'];
    currDataset=ImportDatasetFromCSV(CSVfile);
    DataContainer.(symbol).Month{currContract} = currDataset;

    disp(CSVfile);
end