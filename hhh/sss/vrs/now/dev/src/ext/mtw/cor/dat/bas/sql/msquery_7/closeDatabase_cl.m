function status = closeDatabase_cl(hacc,hDB)
% closeDatabase_cl  Close database in MS Access97
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   status = closeDatabase_cl(hacc,hDB)
%
% Description:
%   This Matlab function closes the database file open in Access97. It
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
%   31-May-1999
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
   
   % Set the open database flag (not OPEN)
   DB_OPEN_FLAG = 0;
   
   % closed database without error
   status = 1;
else
   error('No database open!');
end