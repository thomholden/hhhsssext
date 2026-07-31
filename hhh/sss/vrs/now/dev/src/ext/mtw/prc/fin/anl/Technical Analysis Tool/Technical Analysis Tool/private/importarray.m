function arrayout = importarray(obj,eventdata) %#ok
% tatool helper function to import an array of time series data
% The array must have at least 2 columns (the first column will be assumed
% to be datenums and the second to be price data
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% get names of all fints objects in the base workspace
arraynames = getclassfromworkspace('double');
% ensure the matices have at least 2 columns
for idx = length(arraynames):-1:1
    if (arraynames(idx).size(2) < 2)
        arraynames(idx) = [];
    end
end

if isempty(arraynames)
    msgbox('There are no numeric arrays in the base workspace with at least 2 columns.',...
        'TATOOL','error','modal');
    arrayout = [];
    return
end

% Create a UI to enable the user to select a variable
[anames{1:length(arraynames)}]=deal(arraynames.name);
[selection,ok] = listdlg('ListString',anames,...
    'SelectionMode','single',...
    'ListSize',[160 18*5],...
    'Name','Array Selector',...
    'PromptString','Please select an array.',...
    'OKString','Import');

if ~ok % cancel button was pressed
    arrayout = [];
    return
else % OK was pressed
    % sort according to first column so that latest date is at the top
    arrayout = getvarfromworkspace('base',arraynames(selection).name);
end


