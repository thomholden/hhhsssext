function dataout = indicatordlg(varargin)
% This is a modification of the MATLAB function listdlg (for the UI)
% to suit the input of indicator parameters
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

error(nargchk(1,inf,nargin))

figname = '';
promptstring = {};
inputstrings = {};
inputdefaults = {};
okstring = 'OK';
cancelstring = 'Cancel';
fus = 8;
ffs = 8;
uh = 18;

if mod(length(varargin),2) ~= 0
    % input args have not com in pairs
    error('Arguments must come param/value in pairs.')
end
for i=1:2:length(varargin)
    switch lower(varargin{i})
        case 'name'
            figname = varargin{i+1};
        case 'promptstring'
            promptstring = varargin{i+1};
        case 'inputstrings'
            inputstrings = varargin{i+1};
            for jdx = 1:length(inputstrings)
                if ~ischar(inputstrings{jdx})
                    error(['''InputStrings'' property must be strings.  One is currently a ',class(inputstrings{jdx})]);
                end
            end
        case 'inputdefaults'
            inputdefaults = varargin{i+1};
            for jdx = 1:length(inputdefaults)
                if ~isa(inputdefaults{jdx},'double') || numel(inputdefaults{jdx}) ~= 1
                    error('''InputDefaults'' property must be a cell of scalar numbers.');
                end
            end
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
        otherwise
            error(['Unknown parameter name passed to ',mfilename,'. Name was ' varargin{i}])
    end
end
% Ensure inputdefaults variable is same length as inputstrings variable
if length(inputstrings) < length(inputdefaults)
    inputdefaults(length(inputstrings)+1,end)=[];
elseif length(inputstrings) > length(inputdefaults)
    [inputdefaults{length(inputdefaults)+1:length(inputstrings)}]=deal(0);
end

boxsize = [250 length(inputstrings)*(uh+fus)];

if ischar(promptstring)
    promptstring = cellstr(promptstring); 
end

ex = get(0,'defaultuicontrolfontsize')*1.7;  % height extent per line of uicontrol text (approx)

fp = get(0,'defaultfigureposition');
w = 2*(fus+ffs)+boxsize(1);
h = 2*ffs+6*fus+ex*length(promptstring)+boxsize(2)+uh;
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
        boxsize(2)+3*fus+ex*length(promptstring)])

if ~isempty(promptstring)
    prompt_text = uicontrol('style','text','string',promptstring,...
        'horizontalalignment','left','units','pixels',...
        'position',[ffs+fus fp(4)-(ffs+fus+ex*length(promptstring)) ...
            boxsize(1) ex*length(promptstring)]); %#ok
end

btn_wid = (fp(3)-2*(ffs+fus)-fus)/2;

% first column is just text prompts
for idx = 1:length(inputstrings)
    uicontrol('style','text',...
        'string',inputstrings{1+end-idx},...
        'HorizontalAlignment','left',...
        'position',[ffs+fus ffs+(3+idx)*fus+idx*uh btn_wid uh]);
    
    % second column is the edit boxes
    uicontrol('style','edit',...
        'string',num2str(inputdefaults{1+end-idx}),...
        'HorizontalAlignment','right',...
        'backgroundcolor','w',...
        'position',[ffs+2*fus+btn_wid ffs+(3+idx)*fus+idx*uh btn_wid uh],...
        'tag','editboxes');
end

ok_btn = uicontrol('style','pushbutton',...
    'string',okstring,...
    'position',[ffs+fus ffs+fus btn_wid uh],...
    'callback',@doOK); %#ok

cancel_btn = uicontrol('style','pushbutton',...
    'string',cancelstring,...
    'position',[ffs+2*fus+btn_wid ffs+fus btn_wid uh],...
    'callback',@doCancel); %#ok
try
    set(fig, 'visible','on');
    uiwait(fig);
catch
    if ishandle(fig)
        delete(fig)
    end
end

if isappdata(0,'IndicatorDialogAppData')
    ad = getappdata(0,'IndicatorDialogAppData');
    dataout = ad.indicatordata;
    rmappdata(0,'IndicatorDialogAppData')
else
    % figure was deleted
    dataout = [];
end

function doOK(obj, evd) %#ok
% first validate inputs to all be scalar integers
heb = findall(gcbf,'Tag','editboxes');
lid = length(heb);
ad.indicatordata = cell(1,lid);
for idx = 1:length(heb)
    thisstr = get(heb(idx),'String');
    try
        thisval = str2num(thisstr); %#ok
    catch
        str = {'Only integer numbers are valid.',...
                'Please check your input data and try again.'};
        errordlg(str,'Indicators Input Error','modal');
        return
    end
    if ~isscalarinteger(thisval)
        str = {'Only integer numbers are valid.',...
                'Please check your input data and try again.'};
        errordlg(str,'Indicators Input Error','modal');
        return
    else
        ad.indicatordata{idx} = thisval;
    end
end
% to get here the inputs must be valid
setappdata(0,'IndicatorDialogAppData',ad)
delete(gcbf);

function doCancel(obj, evd) %#ok
ad.indicatordata = [];
setappdata(0,'IndicatorDialogAppData',ad)
delete(gcbf);
