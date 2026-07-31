function status = msquery
% msquery  Graphical User Interface to link Matlab workspace to MS
% Access 2002
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage: 
%   status = msquery
%
% Description:
%   This Matlab function calls the msqueryGUI function which generates a window
%   and initializes this window. msqueryGUI enables the user to easily
%   transfer existing queries from Access to the Matlab workspace or to generate
%   new queries by passing an SQL statement to Access an having the results 
%   returned to the Matlab workspace.
%
% Input:
%   n/a
%
% Output:
%   status = 1 if exits without error 
%
% Author:
%   Blair Greenan
%   Bedford Institute of Oceanography
%   07-Dec-2001
%   Matlab 5.2, 5.3, 6.0 & 6.1 & 7.0
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% Define Global variable which tracks whether there is an open database
global DB_OPEN_FLAG;

% Produce figure with uicontrols
msqueryGUI
%
%%%%%%%%%%%%%%% Initialize all the objects on the form %%%%%%%%%%%%%
%
hFilePathText = findobj(gcbf,'Tag','FilePathText');
set(hFilePathText,'String','');
%
hTableList = findobj(gcbf,'Tag','TableList');
set(hTableList,'String','');
%
hFieldList = findobj(gcbf,'Tag','FieldList');
set(hFieldList,'String','');
%
hQueryList = findobj(gcbf,'Tag','QueryList');
set(hQueryList,'String','');
%
hSQLEdit = findobj(gcbf,'Tag','SQLEdit');
set(hSQLEdit,'String','SELECT ');

% Set the open database flag
DB_OPEN_FLAG = 0;

% made it this far without error
status = 1;
