function status = msqueryExit(varargin)
% msqueryExit  Exit properly from the msquery program
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage: 
%   status = msqueryExit
%
% Description:
%   This Matlab function checks to see if a database is open, and if it is,
%   closes the database file and shuts down the ActiveX automation server
%   (Access97). It thens closes the figure windows and clears the global
%   workspace.
%
% Input:
%   hacc - handle for the ActiveX Automation server (MS Access97)
%   hDB - handle of the database opened by the DAO Database Engine 
%
% Output:
%   status = 1 if exits without error 
%
% Author:
%   Blair Greenan
%   Bedford Institute of Oceanography
%   October 11, 1998
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% If there is an open database, close it
if (nargin == 2)
   hacc = varargin{1}
   hDB = varargin{2}
   closeDatabase(hacc,hDB);
end

% clsoe the GUI window
close(gcbf);

% clear all the global variables
clear global;

% made it this far without error
status = 1;
