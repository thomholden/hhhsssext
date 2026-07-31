function uimenutimerangecb(obj,eventdata) %#ok
% tatool helper function for plotting specific time ranges
% This sets the x-axis range of all current and future plots
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% May want to call this function from places other than a uimenu callback
% e.g. call this routine after creating a new plot so that the new plot's
% x-axis can be set to be the same as existing plots.

ad = guidata(obj);
% remove 'uimenutimerange' from the object's Tag.  he pass the remaining
% string to determine what date range is required
rangeinfo = strrep(get(obj,'Tag'),'uimenutimerange','');

% parse the calling object's Tag to determine if we're talking about 'all',
% 'ytd','days','months' or 'years', and 1, 2, 5, 10, 30 etc.
if (strcmp(rangeinfo,'all') || strcmp(rangeinfo,'ytd'))
    % all dates have been asked for
    rangenum = [];
    rangestr = rangeinfo;
else
    % check to see if the first 2 elements are a number i.e. 30 or 10
    rangenum = str2num(rangeinfo(1:2)); %#ok
    rangestr = rangeinfo((3:end));
    if isempty(rangenum)
        % if not then only the first element is a number i.e. 2 or 5
        rangenum = str2num(rangeinfo(1)); %#ok
        rangestr = rangeinfo((2:end));
    end
end

% now set the date range (on all axes)
for idx = 1:length(ad.axestags)
    axes(ad.handles.(ad.axestags{idx}));  % set axis
    setdaterange(rangestr,rangenum); % set its range
end

% Move the check mark indicating which period is showing
set(get(get(obj,'Parent'),'Children'),'Checked','off');
set(obj,'Checked','on');

% Save the current date range setting so that it can be used if new axes
% (i.e. indicators) are added
ad.daterange.str = rangestr;
ad.daterange.num = rangenum;
guidata(obj,ad);

% When manipulating axes MATLAB automatically turns the zoom off, so need
% to check where tatool thinks it should be and put it back on in needed
resetzoom(ad.handles.tatoolfig);

% Workaround for bug in usage of LEGEND in R14SP1
axislocations_set(gcbo);