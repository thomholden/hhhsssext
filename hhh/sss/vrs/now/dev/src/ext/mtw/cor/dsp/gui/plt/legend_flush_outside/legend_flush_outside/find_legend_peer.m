function axes_handle = find_legend_peer(legend_handle)
% Returns the handle to a axes that's associated with the given legend.
%
% axes_handle = find_legend_peer(legend_handle)
%
% Input:
%   legend_handle           Handle to legend in these axes.
%
% Output:
%   axes_handle             

% Kevin J. Delaney
% May 18, 2011

    axes_handle = [];

    if ~exist('legend_handle', 'var')
        help(mfilename);
    end

    if any(~ishandle(legend_handle))
        errordlg('Input "legend_handle" contains an invalid handle.', ...
            mfilename);
        return
    end

    if any(isempty(legend_handle))
        return
    end

    if length(legend_handle) > 1
        axes_handle = arrayfun(@(x) find_legend_peer(x), legend_handle);
        return
    end

    legend_userdata = get(legend_handle, 'UserData');

    if isempty(legend_userdata) || ~isstruct(legend_userdata) || ~isfield(legend_userdata, 'PlotHandle')
        errordlg('Unable to find valid .UserData for this legend.', mfilename);
        return
    end
        
    axes_handle = legend_userdata.PlotHandle;
end