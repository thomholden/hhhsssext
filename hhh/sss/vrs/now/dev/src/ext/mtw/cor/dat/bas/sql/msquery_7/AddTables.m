function status = AddTables(hDB)
% AddTables  Update the "SQL" editbox by adding selected table
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   status = AddTables(hDB)
%   Not accessed at the command line. Executed by callback of the
%   "Add to SQL" pushbutton
%
% Description:
%   Updates the string in the "SQL" editbox if the user selects
%   a table in the "Tables" listbox and clicks the "Add to SQL" 
%   button at the bottom of the listbox.
%
% Input:
%   hDB - handle of the database opened by the DAO Database Engine 
%
% Output:
%   n/a
%
% Author:
%   Blair Greenan
%   Bedford Institute of Oceanography
%   October 11, 1998
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% Get the Table name selected in the "Tables" listbox
hTableList = findobj(gcbf,'Tag','TableList');
TDValue = get(hTableList,'Value');
TDString = get(hTableList,'String');
TDName = TDString{TDValue};

% Get the string in the SQL editbox.
hSQLEdit = findobj(gcbf,'Tag','SQLEdit');
SQLString2D = get(hSQLEdit,'String');

% concatenate the two strings
SQLString2D = strvcat(SQLString2D,TDName);
set(hSQLEdit,'String',SQLString2D);

%
% Got this far without error
status = 1;

