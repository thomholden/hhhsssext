function status = AddFields(hDB)
% AddFields  Update the "SQL" editbox by adding selected fields
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   status = AddFields(hDB)
%   Not accessed at the command line. Executed by callback of the
%   "Add to SQL" pushbutton
%
% Description:
%   Updates the string in the "SQL" editbox if the user selects
%   a field(s) in the "Fields" listbox and clicks the "Add to SQL" 
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

% Get the field(s) names selected in the "Fields" listbox
hFieldList = findobj(gcbf,'Tag','FieldList');
FDValue = get(hFieldList,'Value');
FDString = get(hFieldList,'String');
FDName = FDString(FDValue);

% Update the string in the SQL editbox with the fields chosen.
% This procedure prefixes the field names with "tablename." to
% avoid confusion over which which table the field is associated with.
hSQLEdit = findobj(gcbf,'Tag','SQLEdit');
SQLString2D = get(hSQLEdit,'String');
SQLString = '';

for i = 1:length(FDName)
   SQLString = [SQLString,TDName,'.',FDName{i},', '];
end
SQLString2D = strvcat(SQLString2D,SQLString);
set(hSQLEdit,'String',SQLString2D);

% Got this far without error
status = 1;

