function ftsout = importfints(obj,eventdata) %#ok
% tatool helper function to import a Financial Time Series object
% The time series must have a field called 'dates' and a field called either
% 'price' or 'close'
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% get names of all fints objects in the base workspace
fts = getclassfromworkspace('fints');

% create UI to do the selection
if isempty(fts)
    msgbox('There are no Financial Time Series Objects in the workspace.',...
        'TATOOL','error','modal');
    ftsout = [];
    return
end

% Create a UI to enable the user to select a FINTS object
[ftsnames{1:length(fts)}]=deal(fts.name);
[selection,ok] = listdlg('ListString',ftsnames,...
    'SelectionMode','single',...
    'ListSize',[160 18*5],...
    'Name','FTS Selector',...
    'PromptString','Please select a time series.',...
    'OKString','Import');

if ~ok % cancel button was pressed
    ftsout = [];
    return
else
    ftsout = getvarfromworkspace('base',fts(selection).name);
end


