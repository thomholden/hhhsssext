function dataout = yahoodlg(varargin)
% This is a modification of the MATLAB function listdlg (for the UI)
% combined with some code for reading from a icharts.yahoo.com
%
% Example:
% None needed - this is a UI helper function that should not be called
% directly
%

error(nargchk(1,inf,nargin))

figname = '';
promptstring = {};
okstring = 'Ok';
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
            error(['Unknown parameter name passed to YAHOODLG.  Name was ' varargin{i}])
    end
end
boxsize = [250 4*uh];

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

if ischar(promptstring)
    prompt_text = uicontrol('style','text','string',promptstring,...
        'horizontalalignment','left','units','pixels',...
        'position',[ffs+fus fp(4)-(ffs+fus+ex*length(promptstring)) ...
            boxsize(1) ex*length(promptstring)]); %#ok
end

btn_wid = (fp(3)-2*(ffs+fus)-fus)/2;

% first column is just text prompts
tickerprompt = uicontrol('style','text',...
    'string','Ticker Symbol:',...
    'HorizontalAlignment','left',...
    'position',[ffs+fus ffs+6*fus+3*uh btn_wid uh],...
    'tag','tickerprompt');  %#ok
sdateprompt = uicontrol('style','text',...
    'string','Start Date (mm/dd/yyyy):',...
    'HorizontalAlignment','left',...
    'position',[ffs+fus ffs+5*fus+2*uh btn_wid uh],...
    'tag','sdateprompt'); %#ok
edateprompt = uicontrol('style','text',...
    'string','End Date (mm/dd/yyyy):',...
    'HorizontalAlignment','left',...
    'position',[ffs+fus ffs+4*fus+uh btn_wid uh],...
    'tag','edateprompt'); %#ok

% second column is the edit boxes
tickeredit = uicontrol('style','edit',...
    'string','^DJI',...%'Ticker',...
    'HorizontalAlignment','right',...
    'backgroundcolor','w',...
    'position',[ffs+2*fus+btn_wid ffs+6*fus+3*uh btn_wid uh],...
    'tag','tickereditbox'); %#ok
temp =  datevec(now);
yearToday = temp(1);
sdateedit = uicontrol('style','edit',...
    'string',['01/01/',num2str(yearToday)],... %'MM/DD/YYYY',...
    'HorizontalAlignment','right',...
    'backgroundcolor','w',...
    'position',[ffs+2*fus+btn_wid ffs+5*fus+2*uh btn_wid uh],...
    'tag','sdateeditbox'); %#ok
edateedit = uicontrol('style','edit',...
    'string',datestr(now-1,'mm/dd/yyyy'),...%'MM/DD/YYYY',...
    'HorizontalAlignment','right',...
    'backgroundcolor','w',...
    'position',[ffs+2*fus+btn_wid ffs+4*fus+uh btn_wid uh],...
    'tag','edateeditbox'); %#ok

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

if isappdata(0,'YahooDialogAppData')
    ad = getappdata(0,'YahooDialogAppData');
    dataout = ad.readticker;
    rmappdata(0,'YahooDialogAppData')
else
    % figure was deleted
    dataout = [];
end

function doOK(obj, evd) %#ok
% Read time series (if possible) thoring up various error or waitbar gui's
% along the way.

% first validate dates
sdatestr = get(findall(gcbf,'Tag','sdateeditbox'),'String');
if ~strcmp(sdatestr([3 6]),'//');
    errordlg([sdatestr,' is not a valid date format.'],'Date Format Error','modal');
    return
end
try    
    sdate = datenum(sdatestr);
catch
    errordlg([sdatestr,' is not a valid starting date.'],'Start Date Error','modal');
    return
end  
edatestr = get(findall(gcbf,'Tag','edateeditbox'),'String');
if ~strcmp(edatestr([3 6]),'//');
    errordlg([edatestr,' is not a valid date format.'],'Date Format Error','modal');
    return
end
try    
    edate = datenum(edatestr);
catch
    errordlg([edatestr,' is not a valid ending date.'],'End Date Error','modal');
    return
end 
if sdate>edate
    errordlg('Start date must be the same as or before the end date','Date Error','modal');
    return
end 

hwait = waitbar(0,'Reading Data.  Please wait...');
ad.readticker.ticker = get(findall(gcbf,'Tag','tickereditbox'),'String');
sdate = datestr(sdate,23);
monthSdate = num2str(round(str2double(sdate(1:2))-1));
edate = datestr(edate,23);
monthEdate = num2str(round(str2double(edate(1:2))-1));
% Form URL to read.  Note that months go from 0 to 11.
try
    urlstr = ['http://ichart.yahoo.com/table.csv?s=',...
            ad.readticker.ticker,'&a=',monthSdate,'&b=',sdate(4:5),'&c=',sdate(7:end),...
            '&d=',monthEdate,'&e=',edate(4:5),'&f=',edate(7:end),'&g=d&ignore=.csv'];
    data = urlread(urlstr);
catch
    close(hwait);
    str ={'There is a problem reading from http://finance.yahoo.com.';
        'Check your ticker symbol, dates and internet connection, then';
        'try again.'};
    errordlg(str,'URL Read Error','modal');
    return
end
if ~strcmp(data(1:4),'Date')
    % Read worked but the returned data isn't correct format
    close(hwait);
    str ={'There is a problem reading from http://finance.yahoo.com.';
        'Check your ticker symbol, dates and internet connection, then';
        'try again.'};
    errordlg(str,'URL Read Error','modal');
    return
end
delete(gcbf);
hwait = waitbar(0,hwait,'Formatting Columns.  Please wait...');
ad.readticker.sdate = sdate;
ad.readticker.edate = edate;
% need to filter the data a little
% firstly find the location of carriage returns
crets = findstr(data,char(10));
dates = cell(length(crets)-1,1);  % preallocate dates matrix
% Now loop through the (long string) extracting the dates and blanking out
% their positions
for idx = 1:length(crets)-1
    waitbar(idx/(length(crets)-1),hwait);
    % find location of first comma (in the first 15 chars of the line)
    allcommas = strfind(data(crets(idx)+1:crets(idx)+15),',');
    firstcomma = allcommas(1);
    dates{idx}=data(crets(idx)+1:crets(idx)+firstcomma-1);
    data(crets(idx)+1:crets(idx)+firstcomma)=' ';
%     if strcmp(data(crets(idx)+11),',')
%         % day of dates is 2007-10-31
%         dates(idx,:)=data(crets(idx)+1:crets(idx)+9);
%         data(crets(idx)+1:crets(idx)+10)=' ';
%     elseif strcmp(data(crets(idx)+10),',')
%         % day of dates is 2007-10-31
%         dates(idx,:)=data(crets(idx)+1:crets(idx)+9);
%         data(crets(idx)+1:crets(idx)+10)=' ';
%     else
%         % day of date is 1-9
%         dates(idx,1:8)=data(crets(idx)+1:crets(idx)+8);
%         dates(idx,end)=' ';
%         data(crets(idx)+1:crets(idx)+9)=' ';
%     end
end
delete(hwait);
hwait = waitbar(0.5,'Formatting Dates.  Please Wait...');
% convert dates to datenums
ad.readticker.dates = datenum(dates,'yyyy-mm-dd');
% save the column names - need to loop over a comma separated string
str = data(6:crets(1)-2);
str = strrep(str,'. ','_');
commas = [0 findstr(str,',')];
ad.readticker.columns = cell(1,length(commas));
delete(hwait);
hwait = waitbar(0,'Formatting Time Series Names.  Please Wait...');
for idx = 1:length(commas)-1
    waitbar(idx/(length(commas)-1),hwait);
    ad.readticker.columns{idx} = str(commas(idx)+1:commas(idx+1)-1);
end
ad.readticker.columns{end} = str(commas(end)+1:end);
% convert data to a numeric array
ad.readticker.data = str2num(data(crets(1)+1:crets(end)-1)); %#ok

setappdata(0,'YahooDialogAppData',ad)
delete(hwait);

function doCancel(obj, evd) %#ok
ad.readticker = [];
setappdata(0,'YahooDialogAppData',ad)
delete(gcbf);
