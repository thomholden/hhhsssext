function vars = getclassfromworkspace(classnames)
% tatool helper function for getting the name of all variables of a
% given class from the base workspace
% classname may be a cell array of names to keep
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if nargin ~=1 || ~(isa(classnames,'cell') || isa(classnames,'char'))
    str=[mfilename,' requires one input - either a string or a cell array of strings.'];
    error(str);
end

vars =  evalin('base','whos'); % all data in the workspace
% now remove everything not of specified class
for idx = length(vars):-1:1
    if ~any(strcmp(classnames,vars(idx).class))
        vars(idx) = [];
    end
end
if isempty(vars)
    vars = [];
end