function status = closeDatabase(hacc,hDB)
% closeDatabase  Close database in MS Access97 and reintialize Matlab GUI
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   status = closeDatabase(hacc,hDB)
%   Not accessed at the command line. Executed by the CloseDatabase uimenu
%   or uicontrol (pushbutton)
%
% Description:
%   This Matlab function closes the database file open in Access97 and
%   reintializes the various uicontrols on the msquery figure window. It
%   also shuts down the activeX automation server (Access97).
%
% Input:
%   hacc - handle for the ActiveX Automation server (MS Access97)
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

% Define Global variable which tracks whether there is an open database
global DB_OPEN_FLAG;

if DB_OPEN_FLAG
   % close the database file in the Access Application object
   invoke(hacc,'closecurrentdatabase');
   
   % release the activeX handle for the DBEngine object 
   release(hDB);
   
   % Shut down the ActiveX automation server (Access97)
   delete(hacc);
   
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
   
   % Set the open database flag (not OPEN)
   DB_OPEN_FLAG = 0;
   
   % closed database without error
   status = 1;
end