function [hacc, hDB] = openDatabase
% openDatabase  Open a database file in MS Access97 and intialize Matlab GUI
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   [hacc, hDB] = openDatabase
%   Not accessed at the command line. Executed by the OpenDatabase uimenu
%   or uicontrol (pushbutton)
%
% Description:
%   This Matlab function prompts the user to chose an Access database file
%   (*.mdb) and then initiates MS Access97 as an ActiveX Automation server.
%   The database is both loaded into the application object (visible on the
%   screen) and into the Data Access Objects (DAO) Database Engine (DBEngine).
%   The list of Tables, Fields and Queries are determined for this database
%   and displayed in the appropriate list boxes in the GUI.
%
% Input:
%   n/a
%
% Output:
%   hacc - handle for the ActiveX Automation server (MS Access97)
%   hDB - handle of the database opened by the DAO Database Engine 
%
% Author:
%   Blair Greenan
%   Bedford Institute of Oceanography
%   October 11, 1998
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% History
% Version 1.1 08-Jan-2001 B. Greenan added code at to check for and remove 
%									old "TempSQL" queries left over from a crash


% Define Global variable which tracks whether there is an open database
global DB_OPEN_FLAG;

% Open dialog box to allow user to select database. Returns two strings
% containing the path to the mdb file and the file name.
[filename, pathname] = uigetfile('*.mdb', 'Open Database File');

% Update the text box in the GUI with the complete path and filename
hFilePathText = findobj(gcbf,'Tag','FilePathText');
set(hFilePathText,'String',[pathname filename]);

% establish MS Access as ActiveX automation server
hacc = actxserver('Access.Application');

% Open a database window in Access
hopen = invoke(hacc,'opencurrentdatabase',[pathname,filename]);

% Minimize the Access Window
set(hacc,'Visible',0);

% Get handle for the DBEngine Workspace 
hWksp = get(hacc.DBEngine,'Workspaces');

% Count the number of workspaces
WkspCnt = get(hWksp,'Count');
WkspCnt = double(WkspCnt);
release(hWksp);

% Open the database in the DBEngine workspace
hDB = invoke(hacc.DBEngine,'OpenDatabase',[pathname,filename]);

% Retrieve the name of the database
DBName = get(hDB,'Name');

% Count the number of TableDefs
TDCnt = get(hDB.TableDefs,'Count');
TDCnt = double(TDCnt);

% make up a cell array containing the list of tables in the database
j = 1;
for i = 1:TDCnt
   hTD = get(hDB,'TableDefs',(i-1));
   TDTemp= get(hTD,'Name');
   % there appear to be some system tables in the DB that I don't
   % want displayed, so weed these "MSys*" tables out
   if ~strncmp('msys',lower(TDTemp),4)
      TDName{j} = TDTemp;
      j = j + 1;
   end
   release(hTD);
end

% find the handle of the "Tables" listbox
hTableList = findobj(gcbf,'Tag','TableList');
TDLength = length(TDName);

% Update the string presented in the listbox and highlight the first item
set(hTableList,'String',TDName(1:TDLength),'Value',1);


% Since the first item in the "Tables" listbox is highlighted
% we need to get the appropriate field names to display in the
% "Fields" listbox.
hTD = get(hDB,'TableDefs',0);
TDName = get(hTD,'Name');
release(hTD);

% Open a recordset in the DBEngine containing the data which makes up the
% chosen table. All manipulations of data in Access97 occur in recordsets
% NOT in the table and query definitions.
hRSet = invoke(hDB,'OpenRecordset',TDName);
FLDCnt = get(hRSet.Fields,'Count');
FLDCnt = double(FLDCnt);

% make up a cell array containing the list of fields in the table
for i = 1:FLDCnt
   hFLD = get(hRSet,'Fields',(i-1));
   FLDName{i} = get(hFLD,'Name');
   release(hFLD);
end
% close the recordset and release the activeX handle
invoke(hRSet,'Close');
release(hRSet);

% find the handle of the "Fields" listbox
hFieldList = findobj(gcbf,'Tag','FieldList');

% Update the string presented in the listbox and highlight the first item
set(hFieldList,'String',FLDName,'Value',1);

% Count the number of Query definitions in the Access database
QDCnt = get(hDB.QueryDefs,'Count');
QDCnt = double(QDCnt);

% make up a cell array containing the list of qeuries defined in the database
j = 1;
for i = 1: QDCnt
   hQD = get(hDB,'QueryDefs',(i-1));
   QDName{j} = get(hQD,'Name');
   if (strcmpi(QDName{j},'TempSQL'))
      % Remove temporary Query (tempSQL) from the Query Defintions 
      invoke(hDB.QueryDefs,'Delete','TempSQL');
      j = j - 1;
   end
   release(hQD);
   j = j + 1;
end

% find the handle of the "Existing Queries" listbox
hQueryList = findobj(gcbf,'Tag','QueryList');
QDLength = length(QDName);

% Update the string presented in the listbox and highlight the first item
set(hQueryList,'String',QDName(1:QDLength),'Value',1);

% Set the open database flag
DB_OPEN_FLAG = 1;

