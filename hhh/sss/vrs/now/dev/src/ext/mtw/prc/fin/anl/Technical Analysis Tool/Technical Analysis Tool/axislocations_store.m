function axislocations_store(obj)
% tatool helper function to store current axes locations and so that
% if MATLAB automatically changes the axes locations they can be reset
% to their expected postions.
% This is needed to work around a bug in MATLAB R14 SP1 regarding
% repositioning axes that have legends on them
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);

if isfield(ad,'axestags')
    % Firstly get the number of axes
    na = length(ad.axestags);
    loc = nan*ones(na,4);
    % then get their locations
    for idx = 1:na
        loc(idx,:) = get(ad.handles.(ad.axestags{idx}),'Position');
    end
    ad.axeslocations = loc;
    guidata(obj,ad);  % store expected locations
end

    