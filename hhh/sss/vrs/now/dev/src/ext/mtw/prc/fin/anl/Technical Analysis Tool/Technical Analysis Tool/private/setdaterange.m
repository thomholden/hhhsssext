function setdaterange(rangestr,rangenum)
% function setdaterange(rangestr,rangenum)
% Function for setting the date range of the current axes.  Typically used
% on an axis that has technical analysis time series' plotted on it.
% The rangestr can be one of 'all', 'ytd', 'days', 'months' or 'years'
% For 'all' and 'ytd' the rangenum (if any) is ignored, otherwise it
% specified the number of days, months or years to view.
%
% The end point for all data ranges is the latest date available.
% The y-axis is scaled to be 5% above max and below the min data for the
% specified range
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if nargin <1 || nargin>2
    str = [mfilename,' must be called with 1 or 2 inputs.'];
    error(str);
end
if ~ischar(rangestr) || numel(rangestr)~=length(rangestr)
    str = ['First input to ',mfilename,' must be a string'];
    error(str);
end
if (nargin == 2 && ~isempty(rangenum))
    if ~isa(rangenum,'double') || numel(rangenum)~=1 || mod(rangenum,1)~=0
        str = ['Second input to ',mfilename,' must be a scalar integer'];
        error(str);
    end
end
if rangenum <= 1
    str = 'The range number must be strictly greater than 1.';
    error(str);
end

% Get handles to children -- assuming they are all lines.  Could
% possibly use hc = findall(gca,'Parent',gca,'Type','line'); instead
hc = get(gca,'Children');
nchildren = length(hc);

% Need to get all the data
xdata = [];
ydata = [];
for idx = 1:nchildren
    xdata = [xdata get(hc(idx),'XData')]; %#ok
    ydata = [ydata get(hc(idx),'YData')]; %#ok
end
uxd =  unique(xdata);

% Calculate the extent of the x-data
uxdmax = uxd(end); % because unique also sorts
switch rangestr
    case 'all'
        uxdmin = uxd(1);
    case 'ytd'
        [y,m,d] = datevec(uxdmax); %#ok year, month and day of last point
        uxdmin = datenum(y,1,1);
    case 'days'
        uxdmin = uxd(max(1,end-rangenum+1)); % need max for case where < rangenum points
    case 'months'
        [y,m,d] = datevec(uxdmax); % year, month and day of last point
        if m>rangenum % if month>=april then just take 3
            m = m-rangenum;
        else % else go back to end of previous year
            m = m-rangenum+12;
            y = y-1;
        end
        uxdmin = datenum(y,m,d);
    case 'years'
        [y,m,d] = datevec(uxdmax); % year, month and day of last point
        uxdmin = datenum(y-rangenum,m,d);
end
% ensure that you only go back as far as the earliest data point
uxdmin = max(uxdmin,uxd(1));

% Render the new range
setdatelimits(xdata,ydata,uxdmin,uxdmax);
