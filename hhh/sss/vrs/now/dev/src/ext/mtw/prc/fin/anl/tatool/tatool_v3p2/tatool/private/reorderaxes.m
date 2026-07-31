function reorderaxes(obj)
% tatool helper function for allowing the user to reorder the axes.  Note
% that the mainaxes (containing the price series data) is restricted to be
% the top most axes
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);

try
    % use the current axes order (with a space added in the name for
    % readability)
    oldorder = ad.axestags;
    neworder = reorderdlg(...
        'StaticFirstItem',true,...
        'Name','Axes Reordering',...
        'PromptString',...
        {'Specify the new axes order.',...
            'Note that the main price series axis',...
            'cannot be moved.'},...
        'ListDefault',strrep(oldorder,'axes',' axes'),...
        'OKString','OK');
    % remove the space
    neworder = strrep(neworder,' ','');
catch
    err = lasterr;
    cr = findstr(err,char(10)); % position of carriage returns
    err = err(cr(end)+1:end); % Just take the last line of the error message
    err = strrep(err,'items','axes'); % replace some generic terms with TATOOL specific terms
    err = strrep(err,'item','axis');
    errordlg(err,'TATOOL AXIS REORDERING ERROR','modal');
    return
end

% Get old, rearrange, and set new axes positions
% NOTE: loop from 1, although this is the main axes, which will not move.
% Could be slightly more efficient by looping from 2.
positions = nan*ones(length(neworder),4);
for idx = 1:length(neworder)
    positions(idx,:) = get(ad.handles.(oldorder{idx}),'Position');
end
for idx = 1:length(neworder)
    set(ad.handles.(neworder{idx}),'Position',positions(idx,:));
    legend(ad.handles.(neworder{idx}));
end
% Store new ordering
ad.axestags = neworder;
guidata(obj,ad);
