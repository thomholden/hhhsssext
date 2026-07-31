% Copyright 2013 The MathWorks, Inc.

function dd = ImportDatasetFromDB(conn,symbol,month)

    tableName = [symbol '_' int2str(month)];
    results=fetch(conn, ['select * from ' tableName]);
    currDataset = cell2dataset(results,'VarNames',ColumnNames);

end