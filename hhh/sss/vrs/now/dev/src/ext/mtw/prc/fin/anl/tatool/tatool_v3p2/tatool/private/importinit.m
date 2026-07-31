function importinit(obj,tats)
% tatool helper function to complete the initialization of the main UI
% after loading in data for the FIRST time (and only the first time).
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

if nargin < 2
    str = [mfilename,' requires 2 inputs.'];
    error(str);
end
if ~ishandle(obj)
    str = ['The first input to ',mfilename,' must be a graphics handle.'];
    error(str);
end
if ~istats(tats)
    str = ['The second input to ',mfilename,' must be a tats structure.'];
    error(str);
end

ad = guidata(obj);
if ~isfield(ad.handles,'welcomeinfo')
    error([mfilename,' shouldn''t be called if this is true.']);
    return
end

% Delete the welcome instructions
delete(ad.handles.welcomeinfo);
ad.handles = rmfield(ad.handles,'welcomeinfo');

% Enable the 'Export','Print','Time Range' and 'Indicators' uimenus
henable = [get(ad.handles.uimenufile,'Children');...
        get(ad.handles.uimenuedit,'Children');...
        get(ad.handles.uimenutimerange,'Children');...
        get(ad.handles.uimenuindicators,'Children')];
set(henable,'Enable','on');

% Plot the ta time series data
% Use default axes position info to size then plot price axes
fpos = get(ad.handles.tatoolfig,'Position');
apos = [ad.defaultleftmargin,...
        ad.defaultaxesspacing/2 + ad.sliderwidth + ad.defaultxlabelspacing,...
        fpos(3) - ad.sliderwidth - ad.defaultleftmargin - ad.defaultrightmargin,...
        fpos(4) - ad.sliderwidth - ad.defaultaxesspacing - ad.defaultxlabelspacing - ad.defaulttitlespacing];
atag = 'mainaxes';
ha = axes('Visible','on','Units','pixels',...
    'Box','on',...
    'Tag',atag,...
    'Position',apos);
ad.handles.(atag) = ha;
% create a structure containing the tag of the axis that was
% created and its location
ad.axestags = {atag};

% plot to the axis
plottats(tats);
ad.tats = tats;
title('Raw Price Series');
xlabel('Dates');
grid on;
% set the x axis to show all data and save current setting to app data
ad.daterange.str = 'all';
ad.daterange.num = [];
setdaterange(ad.daterange.str,ad.daterange.num);
% Put a check mark next to 'all' on the 'time range' menu
set(get(ad.handles.uimenutimerange,'Children'),'Checked','off');
set(ad.handles.uimenutimerangeall,'Checked','on');

% Put a check box next to the 'zoom off' uimenuitem
uimenueditcb(ad.handles.uimenueditzoomoff);

% Make figure visible and enable figure resizing
set(ad.handles.tatoolfig,...
    'Visible','on',...
    'Resizefcn',@resizecb,...
    'Resize','on');

% save changes to app data
guidata(obj,ad);

% Workaround for bug in usage of LEGEND in R14SP1
axislocations_store(obj);