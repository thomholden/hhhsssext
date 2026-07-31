function structout = importstruct(obj,eventdata) %#ok
% tatool helper function to import a structure containing time series data
% The structure must have a field called 'dates' and a field called either
% 'price' or 'close'
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% get names of all fints objects in the base workspace
structnames = getclassfromworkspace('struct');
% ensure the structures have appropriate field names
for idx = length(structnames):-1:1
    thisvar = getvarfromworkspace('base',structnames(idx).name);
    if ~((isfield(thisvar.data,'close') || isfield(thisvar.data,'price')) &&...
            isfield(thisvar.data,'dates'))
        structnames(idx) = [];
    end
end

% create UI to do the selection
if isempty(structnames)
    str = {'There are no structures in the base workspace with a field';
        'called ''dates'' and one called either ''close'' or ''price''.'};
    msgbox(str,'TATOOL','error','modal');
    structout = [];
    return
end

% Create a UI to enable the user to select a variable
[snames{1:length(structnames)}]=deal(structnames.name);
[selection,ok] = listdlg('ListString',snames,...
    'SelectionMode','single',...
    'ListSize',[160 18*5],...
    'Name','Array Selector',...
    'PromptString','Please select an array.',...
    'OKString','Import');

if ~ok % cancel button was pressed
    structout = [];
    return
else % OK was pressed
    % sort according to first column so that latest date is at the top
    structout = getvarfromworkspace('base',structnames(selection).name);
end


