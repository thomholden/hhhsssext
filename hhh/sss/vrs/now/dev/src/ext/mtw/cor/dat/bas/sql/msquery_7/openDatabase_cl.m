function [hacc, hDB] = openDatabase_cl(varargin)
% openDatabase_cl  Open a database file in MS Access97
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   [hacc, hDB] = openDatabase_cl(varargin)
%
% Description:
%   This Matlab function prompts the user to chose an Access database file
%   (*.mdb) and then initiates MS Access97 as an ActiveX Automation server.
%   The database is both loaded into the application object (visible on the
%   screen) and into the Data Access Objects (DAO) Database Engine (DBEngine).
%
% Input:
%   varargin - can contain the pathname and filename of the Access97 database
%
% Output:
%   hacc - handle for the ActiveX Automation server (MS Access97)
%   hDB - handle of the database opened by the DAO Database Engine 
%
% Author:
%   Blair Greenan
%   Bedford Institute of Oceanography
%   31-May-1999
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% History
% Version 1.1 08-Jan-2001 B. Greenan added code at to check for and remove 
%									old "TempSQL" queries left over from a crash

% Define Global variable which tracks whether there is an open database
global DB_OPEN_FLAG;

% Determine which Access database to open
if (nargin == 0)
   % Open dialog box to allow user to select database. Returns two strings
   % containing the path to the mdb file and the file name.
   [filename, pathname] = uigetfile('*.mdb', 'Open Database File');
elseif (nargin == 1)
   % assume database file is in pwd
   ['pathname = ', pwd, '\'];
   filename = varargin{1};
elseif (nargin == 2)
   pathname = varargin{1};
   if (~strcmp(pathname(length(pathname)),'\'))
      error('Path must end with a backslash')
   end
   filename = varargin{2};
else
   error('Incorrect number of input arguments')
end

% establish MS Access as ActiveX automation server
hacc = actxserver('Access.Application');

% Open a database window in Access
hopen = invoke(hacc,'opencurrentdatabase',[pathname,filename]);

% Minimize the Access Window
set(hacc,'Visible','0');

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

% Set the open database flag
DB_OPEN_FLAG = 1;


% Following added to Version 1.1
% Do the following to remove any "TempSQL" queries that may have
% been left over from a crash 

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



