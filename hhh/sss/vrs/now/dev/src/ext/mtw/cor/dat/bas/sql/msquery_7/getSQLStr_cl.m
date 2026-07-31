function SQLStr = getSQLStr(hDB,SQLname)
% getSQLStr  Retrieve the string for the query "SQLname"
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   SQLStr = getSQLStr(hDB,SQLname)
%
% Description:
%   This function retrieves the string for the query "SQLname" from the
%   database and returns the string to the Matlab workspace
%
% Input:
%   hDB - handle of the database opened by the DAO Database Engine 
%   SQLname - string containing the name of the query string to retrieve
%
% Output:
%   SQLStr - Matlab string representing the SQL query string
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
% Version 1.0 31-May-1999

% Obtain the ActiveX object handle for the appropriate QueryDef
hQD = get(hDB,'QueryDefs',SQLname);

% Get the SQL string for this QueryDef
SQLStr = get(hQD,'SQL');

% release the ActiveX handle
release(hQD);


