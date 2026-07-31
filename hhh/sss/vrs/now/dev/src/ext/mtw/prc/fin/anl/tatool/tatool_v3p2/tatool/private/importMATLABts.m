function mtsout = importMATLABts(obj,eventdata) %#ok
% tatool helper function to import a MATLAB timeseries object
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% get names of all timeseries objects in the base workspace
ts = getclassfromworkspace('timeseries');

% create UI to do the selection
if isempty(ts)
    msgbox('There are no MATLAB Time Series Objects in the workspace.',...
        'TATOOL','error','modal');
    mtsout = [];
    return
end

% Create a UI to enable the user to select a timeseries object
[tsnames{1:length(ts)}]=deal(ts.name);
[selection,ok] = listdlg('ListString',tsnames,...
    'SelectionMode','single',...
    'ListSize',[160 18*5],...
    'Name','Time Series Selector',...
    'PromptString','Please select a time series.',...
    'OKString','Import');

if ~ok % cancel button was pressed
    mtsout = [];
    return
else
    mtsout = getvarfromworkspace('base',ts(selection).name);
end


