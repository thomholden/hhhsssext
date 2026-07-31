%% Loop through contract month numbers and read from corresponding CSV file
% Use the auto-generated CSV reader to do the actual file reading.
%
% Copyright 2013 The MathWorks, Inc.
for j = MonthContracts
    CSVfile = ['.\Datasets\' symbol int2str(j) '.csv'];
    currDataset=ImportDatasetFromCSV(CSVfile);
    DataContainer.(symbol).Month{j} = currDataset;

    disp(['Reading from CSV: ' CSVfile]);
end