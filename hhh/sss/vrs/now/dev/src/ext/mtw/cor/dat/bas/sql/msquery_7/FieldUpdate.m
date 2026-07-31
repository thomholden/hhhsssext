function status = FieldUpdate(hDB)
% FieldUpdate  Update the "Fields" listbox in msquery GUI
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   status = FieldUpdate(hDB)
%   Not accessed at the command line. Executed by callback in the "Tables"
%   listbox.
%
% Description:
%   If the user clicks on a Table listed in the "Tables" listbox, this
%   function updates the "Fields" listbox so that it corresponds to the
%   Table chosen.
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

% handle of "Tables" listbox
hTableList = findobj(gcbf,'Tag','TableList');

% Which table has been selected?
TDValue = get(hTableList,'Value');

% Retrieve string (cell array) containing names of Tables listed in listbox
TDString = get(hTableList,'String');

% Pick the Table name out of the cell array
TDName = TDString{TDValue};

% Open a recordset for the appropriate TableDef
hRSet = invoke(hDB,'OpenRecordset',TDName);

% Determine the number of fields in the Table
FLDCnt = get(hRSet.Fields,'Count');
FLDCnt = double(FLDCnt);

% start waitbar
hWait = waitbar(0,'Updating Fields List...');

% loop to compile a cell array of field names
for i = 1:FLDCnt
   hFLD = get(hRSet,'Fields',(i-1));
   FLDName{i} = get(hFLD,'Name');
   waitbar(i/FLDCnt);
   release(hFLD);
end
close(hWait);

% Get "Fields" listbox graphics handle
hFieldList = findobj(gcbf,'Tag','FieldList');
set(hFieldList,'String',FLDName,'Value',1);

% close the recordset and release the ActiveX handle
invoke(hRSet,'Close');
release(hRSet);

% Got this far without error
status = 1;

