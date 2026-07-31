function status = saveQuery
% saveQuery - callbacks from msqueryGUI for the "Save Query" checkboxes
% =========================================================================
% msquery  Version 7.0 05-Aug-2004
%
% Usage: 
%   status = saveQuery
%   Used only by msqueryGUI function, NOT used at command line
%
% Description:
%   This function contains the actions to be carried out by the
%   callbacks from msqueryGUI for the "Save Query" checkbox.
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
%   October 8, 1998
%   Matlab 5.2.1
%   greenanb@mar.dfo-mpo.gc.ca
% =========================================================================
%

% "Save Query" Checkbox has been modified

% get handles for edittext box and checkbox
hSQ = findobj(gcbf,'Tag','SaveQueryCheck');
hEdit = findobj(gcbf,'Tag','SaveQueryEdit');
checkVal=get(hSQ,'Value');

% Visibilty of Edit box based on status of Checkbox
if checkVal
   set(hEdit,'Enable','on');
else
   set(hEdit,'Enable','off');
end

% Got this far without error
status = 1;
