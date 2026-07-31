function dataout = reorderdlg(varargin)
% This is a modification of the MATLAB function listdlg
% to enable the order of a list to be changed.
% It's specifically written to allow the user to re-order the axes in
% tatool
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

error(nargchk(1,inf,nargin))

staticfirstitem = false;
figname = '';
promptstring = {};
listdefault = {};
okstring = 'OK';
cancelstring = 'Cancel';
upstring = 'up';
downstring = 'down';
fus = 8;
ffs = 8;
uh = 18;

if mod(length(varargin),2) ~= 0
    % input args have not com in pairs
    error('Arguments must come param/value in pairs.')
end
for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'staticfirstitem'
            staticfirstitem = varargin{i+1};
            if ~islogical(staticfirstitem)
                str = [varargin{i},' must be a logical 0 or 1.'];
                error(str);
            end
        case 'name'
            figname = varargin{i+1};
        case 'promptstring'
            promptstring = varargin{i+1};
        case 'listdefault'
            listdefault = varargin{i+1};
        case 'uh'
            uh = varargin{i+1};
        case 'fus'
            fus = varargin{i+1};
        case 'ffs'
            ffs = varargin{i+1};
        case 'okstring'
            okstring = varargin{i+1};
        case 'cancelstring'
            cancelstring = varargin{i+1};
        case 'upstring'
            upstring = varargin{i+1};
        case 'downstring'
            downstring = varargin{i+1};
        otherwise
            error(['Unknown parameter name passed to ',mfilename,'. Unknown name was ' varargin{i}])
    end
end

if length(listdefault)<=1
    str = 'You cannot reorder a list containing only 1 item.';
    error(str);
    return
end
% If first item is static and length(listdefault)<=2 then can't rearrange anyway so just exist with
% a message
if (staticfirstitem && length(listdefault)<=2)
    str = ['There are only 2 items. Since the first item in the list is restricted not to move ',...
            'you cannot rearrange the items.'];
    error(str);
    return
end

boxsize = [200 max(uh,length(listdefault)*uh)];

if ischar(promptstring)
    promptstring = cellstr(promptstring); 
end

ex = get(0,'defaultuicontrolfontsize')*1.6;  % height extent per line of uicontrol text (approx)

fp = get(0,'defaultfigureposition');
w = 2*(fus+ffs)+boxsize(1);
h = 2*ffs+7*fus+ex*length(promptstring)+boxsize(2)+2*uh;
fp = [fp(1) fp(2)+fp(4)-h w h];  % keep upper left corner fixed

fig_props = { ...
        'name'                   figname ...
        'resize'                 'off' ...
        'numbertitle'            'off' ...
        'menubar'                'none' ...
        'windowstyle'            'modal' ...
        'visible'                'off' ...
        'createfcn'              ''    ...
        'position'               fp   ...
        'closerequestfcn'        'delete(gcbf)' ...
    };

fig = figure(fig_props{:});

uicontrol('style','frame',...
    'position',[1 1 fp([3 4])])
uicontrol('style','frame',...
    'position',[ffs ffs 2*fus+boxsize(1) 2*fus+uh])
uicontrol('style','frame',...
    'position',[ffs ffs+3*fus+uh 2*fus+boxsize(1) ...
        boxsize(2)+4*fus+ex*length(promptstring)+uh])

if isempty(promptstring)
    prompt_text = uicontrol('style','text','string',promptstring,...
        'horizontalalignment','left','units','pixels',...
        'position',[ffs+fus fp(4)-(ffs+fus+ex*length(promptstring)) ...
            boxsize(1) ex*length(promptstring)]); %#ok
end

btn_wid = (fp(3)-2*(ffs+fus)-fus)/2;

% create the up/down buttons and the text box
uicontrol('style','pushbutton',...
    'string',upstring,...
    'Enable','off',...
    'position',[ffs+fus ffs+5*fus+boxsize(2)+uh btn_wid uh],...
    'callback',@doUP,...
    'Tag','up_btn');

if staticfirstitem
    down_enable = 'off';
else
    down_enable = 'on';
end
uicontrol('style','pushbutton',...
    'string',downstring,...
    'Enable',down_enable,...
    'position',[fp(3)-ffs-fus-btn_wid ffs+5*fus+boxsize(2)+uh btn_wid uh],...
    'callback',@doDOWN,...
    'Tag','down_btn');


% create the text box with a frame around it
uicontrol('style','frame',...
    'position',[ffs+fus-1 ffs+4*fus+uh-1 boxsize+2]);
uicontrol('style','listbox',...
    'string',listdefault,...
    'Value',1,...
    'position',[ffs+fus ffs+4*fus+uh boxsize],...
    'backgroundcolor',[1 1 1],...
    'Callback',@doList,...
    'Tag','listbox');

uicontrol('style','pushbutton',...
    'string',okstring,...
    'position',[ffs+fus ffs+fus btn_wid uh],...
    'callback',@doOK,...
    'Tag','ok_btn');

uicontrol('style','pushbutton',...
    'string',cancelstring,...
    'position',[ffs+2*fus+btn_wid ffs+fus btn_wid uh],...
    'callback',@doCancel,...
    'Tag','cancel_btn');
try
    ad.handles = guihandles(fig);
    ad.staticfirstitem = staticfirstitem;
    guidata(fig,ad);
    set(fig, 'visible','on');
    uiwait(fig);
catch
    if ishandle(fig)
        delete(fig)
    end
end

if isappdata(0,'AxesOrderDialogAppData')
    ad = getappdata(0,'AxesOrderDialogAppData');
    dataout = ad.listbox;
    rmappdata(0,'AxesOrderDialogAppData')
else
    % figure was deleted
    dataout = [];
end

function doUP(obj, evd) %#ok
ad = guidata(obj);
val = get(ad.handles.listbox,'Value');
list = get(ad.handles.listbox,'String');
% swap the list items
list([val-1,val],:) = list([val,val-1],:);
set(ad.handles.listbox,'String',list);
% change the value pointed to
set(ad.handles.listbox,'Value',val-1);
% update the buttons
doList(ad.handles.listbox);

function doDOWN(obj, evd) %#ok
ad = guidata(obj);
val = get(ad.handles.listbox,'Value');
list = get(ad.handles.listbox,'String');
% swap the list items
list([val,val+1],:) = list([val+1,val],:);
set(ad.handles.listbox,'String',list);
% change the value pointed to
set(ad.handles.listbox,'Value',val+1);
% update the buttons
doList(ad.handles.listbox);

function doOK(obj, evd) %#ok
% Poke list into roots appdata
fad = guidata(obj);
ad.listbox = get(fad.handles.listbox,'String');
setappdata(0,'AxesOrderDialogAppData',ad)
delete(gcbf);

function doCancel(obj, evd) %#ok
% just delete the figure
ad.listbox = [];
setappdata(0,'AxesOrderDialogAppData',ad)
delete(gcbf);

function doList(obj, eventdata) %#ok
ad = guidata(obj);
val = get(obj,'Value');
len = length(get(ad.handles.listbox,'String'));
if (ad.staticfirstitem)
    if (val==1) || (len==2)
        set(ad.handles.up_btn,'Enable','off');
        set(ad.handles.down_btn,'Enable','off');
    elseif (val==2)
        set(ad.handles.up_btn,'Enable','off');
        set(ad.handles.down_btn,'Enable','on');
    elseif val==len
        set(ad.handles.up_btn,'Enable','on');
        set(ad.handles.down_btn,'Enable','off');
    else
        set(ad.handles.up_btn,'Enable','on');
        set(ad.handles.down_btn,'Enable','on');
    end
else
    if (len==1)
        set(ad.handles.up_btn,'Enable','off');
        set(ad.handles.down_btn,'Enable','off');
    elseif (val==1)
        set(ad.handles.up_btn,'Enable','off');
        set(ad.handles.down_btn,'Enable','on');
    elseif val==len
        set(ad.handles.up_btn,'Enable','on');
        set(ad.handles.down_btn,'Enable','off');
    else
        set(ad.handles.up_btn,'Enable','on');
        set(ad.handles.down_btn,'Enable','on');
    end
end
        