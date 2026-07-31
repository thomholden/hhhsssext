function dataout = importyahoo(obj,eventdata) %#ok
% tatool helper function to import data from http://finance.yahoo.com
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% Create a UI to enable the user to specify a ticker and dates
% (This is a customization of the MATLAB function listdlg)
data = yahoodlg(...
    'Name','Yahoo Ticker Importer',...
    'PromptString','Please specify a ticker and dates',...
    'OKString','Import');

if ~isempty(data) % Import button was pressed
    dataout = data;
else
    dataout = []; % Cancel button was pressed
end
