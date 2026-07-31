function axislocations_set(obj)
% tatool helper function to set axes locations to their expected locations
% as stored in ad.axeslocations
% Needed to work around a bug in MATLAB R14 SP1 regarding repositioning
% axes that have legends on them
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad=guidata(obj);

if isfield(ad,'axeslocations')
    % Firstly get the expected locations
    loc = ad.axeslocations;
    na = size(loc,1);
    hallaxes = nan*ones(2*na,1);
    % Then make them the actual locations
    for idx = 1:na
        ha = ad.handles.(ad.axestags{idx});
        set(ha,'Position',loc(idx,:));
        hallaxes(na+idx) = ha;
        hallaxes(idx) = legend(ha);
    end
    hallchildren = get(ad.handles.tatoolfig,'Children');
    hallchildren(1:2*na) = hallaxes;
    set(ad.handles.tatoolfig,'Children',hallchildren);
end

% When manipulating axes MATLAB automatically turns the zoom off, so need
% to check where tatool thinks it should be and put it back on in needed
resetzoom(ad.handles.tatoolfig);

    