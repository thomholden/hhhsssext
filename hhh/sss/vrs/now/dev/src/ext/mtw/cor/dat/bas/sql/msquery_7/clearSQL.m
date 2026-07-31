function status = clearSQL
% clearSQL  Clear the text in the "SQL Statement" edit box
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage:
%   status = clearSQL
%   Not accessed at the command line. Executed by callback of the
%   "Clear SQL" pushbutton
%
% Description:
%   Updates the string in the "SQL" editbox ot be "SELECT ".
%
% Input:
%   n/a
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

% Update the string in the SQL editbox.
hSQLEdit = findobj(gcbf,'Tag','SQLEdit');
set(hSQLEdit,'String','SELECT ');
%
% Got this far without error
status = 1;

