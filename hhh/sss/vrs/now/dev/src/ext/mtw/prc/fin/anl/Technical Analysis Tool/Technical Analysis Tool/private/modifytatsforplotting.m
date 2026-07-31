function tatsout = modifytatsforplotting(tatsin)
% tatool helper function for taking a time series with multiple columns of
% data and converting it to one column of data which is suitable for
% plotting.  The idea is that both 'lines' of data will be plotted using
% one MATLAB 'line' command.
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if nargin~=1 || ~istats(tatsin)
    str = ['Input to ',mfilename,' must be a technical analysis time series.'];
    error(str);
end

[m,n]=size(tatsin.data);
if  (n == 1)
    % Input series only has one column so don't need to do anything
    tatsout = tatsin;
    return
else
    % just copy the name
    tatsout.name = tatsin.name;
    % expand out the dates
    dates = [tatsin.dates; tatsin.dates(1)]*ones(1,n);
    dates = dates(:);
    tatsout.dates = dates(1:end-1);
    % exand the data
    data = [tatsin.data; nan*ones(1,n)];
    data = data(:);
    tatsout.data = data(1:end-1);
end