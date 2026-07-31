function SQLString = SQLUpdate(hDB)
% SQLUpdate  Update the "Fields" listbox in msquery GUI
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   status = SQLUpdate(hDB)
%   Not accessed at the command line. Executed by callback in the "Existing 
%   Queryies" listbox.
%
% Description:
%   If the user clicks on a Query listed in the "Existing Queries" listbox, 
%   this function updates the "SQL" editbox so that it corresponds to the
%   SQL statement for the query chosen.
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
%   28-May-1999
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% History
% Version 1.0 11-Oct-1998
% Version 2.0 28-May-1999
%   Modified to pass SQLString back to Matlab workspace. Version 1.0 simply
%   passed back a "status" variable. Now the SQLString is available in the
%   Matlab workspace to print to a file, etc. for recordkeeping.

% handle of "Existing Queries" listbox
hQueryList = findobj(gcbf,'Tag','QueryList');

% Which Query has been selected?
QDValue = get(hQueryList,'Value');

% Obtain the ActiveX object handle for the appropriate QueryDef
hQD = get(hDB,'QueryDefs',(QDValue-1));

% Get the SQL string for this QueryDef
SQLString = get(hQD,'SQL');

% Update the "SQL Statement" editbox in the msquery GUI
hSQLEdit = findobj(gcbf,'Tag','SQLEdit');
set(hSQLEdit,'String',SQLString);

% release the ActiveX handle
release(hQD);

% Got this far without error
%status = 1;

