%% Loop through contract month numbers and read corresponding data from DB
% Meant to be called from within A_DataImport script.
%
% Copyright 2013 The MathWorks, Inc.
conn = database(dbname, '','',dbDriver,connString);

for j = MonthContracts
    tableName = [symbol '_' int2str(j)];
    results=fetch(conn, ['select * from ' tableName]);
    currDataset = cell2dataset(results,'VarNames',ColumnNames);
    
    DataContainer.(symbol).Month{j} = currDataset;
    
    disp(['Database: ' symbol '.' int2str(j)]);
end
close(conn);
