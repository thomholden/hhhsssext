function plottats(tats)
% Function to plot a technical analysis time series structure as created
% and used in tatool
% If there is a legend then it is added to and potentially repositioned
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

% error check
if nargin ~= 1
    error([mfilename,' requires 1 input.']);
end
if ~istats(tats)
    str = ['The input to ',mfilename,' must be a technical analysis time series.',...
            char(10),'See help for ''istats'' for more info.'];
    error(str);
end

% plot the new line with the next available colour
allcolours = get(gca,'ColorOrder');
hlall = findobj(get(gca,'Children'),'Type','line');
nchildren = length(hlall);
if nchildren > 0
    % get the color of the last line plotted
    lastcolour = get(hlall(1),'Color');
    for idx = size(allcolours,1):-1:1
        if all(lastcolour == allcolours(idx,:))
            break
        end
    end
    if idx==7
        nextcolour = allcolours(1,:);
    else
        nextcolour = allcolours(idx+1,:);
    end
else
    nextcolour = allcolours(1,:);
end

hline = line(tats.dates,tats.data,...
    'Parent',gca,...
    'color',nextcolour,...
    'Tag',[strrep(tats.name,':','_'),'line']); %#ok
% NOTE: ther may be colon's in the taseries name but these are invalid in
% tags.  Hence replace any colons with an underscore.

% The following will add to the legend 
hl = legend(gca);
% need to modify the name due to the TEX interpreter
thisname = tats.name;
switch thisname(1)
    case '^'
        thisname = ['\',thisname];
    case '_'
        thisname = ['\',thisname];
end
if isempty(hl)
    % create legend if one didn't exist
    % may need padding to ensure the legend and the line match up
    if nchildren > 0
        pad = cell(1,nchildren+1);
        [pad{:}] = deal('');
        pad{end} = thisname;
    else
        pad = {thisname};
    end
    legend(pad);
else
    lstring = get(findobj(hl,'Type','Text'),'String');
    if isa(lstring,'cell')
        legend(gca,strvcat(lstring{end:-1:1},thisname)); %#ok
    else
        legend(gca,strvcat(lstring,thisname)); %#ok
    end
end

