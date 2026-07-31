function status = delMSQuery(hDB)
% delMSQuery  Delete QueryDef in Access97 database
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   status = delMSQuery(hDB)
%   Not accessed at the command line. Executed by callback of the
%   "Delete Query" pushbutton
%
% Description:
%   Deletes a defined SQL query in an Access97 database (with Access
%   operating as an ActiveX automation server). This query object is 
%   referred to as a QueryDef (part of the DAO DBEngine object hierarchy).
%   Updates the "Existing Queries" listbox in the msquery GUI.
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

% Check the listbox to determine the name of the Query to be deleted
hQueryList = findobj(gcbf,'Tag','QueryList');
QDValue = get(hQueryList,'Value');
QDString = get(hQueryList,'String');
QDName = QDString{QDValue};

% delete the QueryDef in the Access97 database
invoke(hDB.QueryDefs,'Delete',QDName);

% Have to clear QDName here because it is a char array...want to use it as cell array
clear QDName
% Count the number of Query definitions in the Access database
QDCnt = get(hDB.QueryDefs,'Count');
QDCnt = double(QDCnt);
% make up a cell array containing the list of qeuries defined in the database
for i = 1: QDCnt
   hQD = get(hDB,'QueryDefs',(i-1));
   QDName{i} = get(hQD,'Name');
   release(hQD);
end

% find the handle of the "Existing Queries" listbox
hQueryList = findobj(gcbf,'Tag','QueryList');
QDLength = length(QDName);

% Update the string presented in the listbox and highlight the first item
set(hQueryList,'String',QDName(1:QDLength),'Value',1);


%
% Got this far without error
status = 1;

