function varout = getvarfromworkspace(WS,varname)
% TATOOL helper function to get a variable with the given name from the
% workspace with the given name.
% WS can be 'base' or 'caller'
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if nargin ~= 2
    str = [mfilename,' must have exactly 2 inputs.'];
    error(str);
end
if ~(strcmp(WS,'base') || strcmp(WS,'caller'))
    str = [WS,' is not a valid workspace.  Use ''caller'' or ''base'''];
    error(str);
end

try
    varout.name = varname;
    varout.data = evalin(WS,varname);
catch
    error(lasterror);
end