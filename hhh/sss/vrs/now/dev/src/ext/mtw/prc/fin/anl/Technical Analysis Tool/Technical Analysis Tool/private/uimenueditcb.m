function uimenueditcb(obj,eventdata,varargin) %#ok
% tatool helper function for the edit pulldown menu
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

ad = guidata(obj);

switch get(obj,'Tag')
    case 'uimenueditreorder'
        reorderaxes(obj);
    case 'uimenueditzoomon'
        zoom('v6','on'); % This is undocumented and may be removed in a later MATLAB release
        zoom('on');
        cbstr=get(gcbf,'WindowButtonDownFcn');
        set(gcbf,'WindowButtonDownFcn',{@do_zoom,cbstr});
        set(obj,'Checked','on');
        set(ad.handles.uimenueditzoomoff,'Checked','off');
    case 'uimenueditzoomoff'
        zoom('off');
        zoom('v6','off'); % This is undocumented and may be removed in a later MATLAB release
        set(gcbf,'WindowButtonDownFcn',''); % SHouldn;t need this
        set(ad.handles.uimenueditzoomon,'Checked','off');
        set(obj,'Checked','on');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function do_zoom(obj, env, cbstr) %#ok

% evaluate the default callback
eval(cbstr);

% ensure that the axes update correctly
hc = get(gca,'Children');
nchildren = length(hc);

% Need to get all the data
xdata = [];
ydata = [];
for idx = 1:nchildren
    xdata = [xdata get(hc(idx),'XData')]; %#ok
    ydata = [ydata get(hc(idx),'YData')]; %#ok
end
ylim = get(gca,'YLim');
ydata = max(ylim(1),min(ylim(2),ydata));
xlim = get(gca,'XLim');
uxdmin = xlim(1);
uxdmax = xlim(2);
% Render the new range
setdatelimits(xdata,ydata,uxdmin,uxdmax);
% 
ad = guidata(obj);
resetzoom(ad.handles.tatoolfig);

% Workaround for bug in usage of LEGEND in R14SP1
axislocations_set(gcbo);

