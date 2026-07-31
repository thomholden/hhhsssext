% demo_cl
%
% demo_cl demonstrates how to use the command line versions of MSQuery.
% These functions enable the user to include data access queries in 
% another Matlab script and run this without user intervention as is required
% with the GUI version of MSQuery.


% Open the database in MS Access. If a pathname and filename are not
% specified an "Open File" dialog box will appear. Two ActiveX handles
% are returned from the function
[hacc, hDB] = opendatabase_cl('E:\par9612\','par9612.mdb');

% Get the string which corresponds to the Query name passed. If the
% query needed is not already defined in the database, the user
% can simply make up an appropriate "SQLStr" string.
SQLStr = getSQLStr_cl(hDB,'CTDQuery1');

% Execute the query on the database and transfer the data to the Matlab workspace
executeSQL_cl

% Close the database and shutdown Access
status = closedatabase_cl(hacc,hDB);