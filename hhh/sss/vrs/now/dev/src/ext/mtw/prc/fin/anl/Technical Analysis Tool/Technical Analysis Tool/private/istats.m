function flag = istats(instruct)
% tatool helper function to determine whether the input is a technical
% analysis time series structure.
% 'instruct' must have a fields called 'name', 'dates' and 'data'.
% The length of dates and data must be the same.
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if ~isa(instruct,'struct') ||...
        ~isfield(instruct,'name') ||...
        ~isfield(instruct,'dates') ||...
        ~isfield(instruct,'data')
    flag = 0;
elseif size(instruct.dates,1) ~= size(instruct.data,1)
    flag = 0;
else
    flag =1 ;
end
