function varargout = RTviewer(varargin)
% RTVIEWER GUI to monitor the prices of stocks using the Datafeed Toolbox
% 
% This demo shows how TIMER objects can be used to create a "real-time"
% trading appliction with MATLAB.
%
% Using the Datafeed Toolbox (Bloomberg or Yahoo) to import live market
% data or MATLAB's random number generation, this tool plots the data as it
% is imported or created, and displays whether the last price is higher or
% lower than the previous price.  If the price is higher, the point on the
% graph is plotted in green.  If it is lower, it is plotted as red.
% Otherwise it is plotted blue.
%
% This program could be used as a starting point to creating more detailed
% real-time trading applications.
%
% Author:
% Brian Kiernan
% Application Engineer
% The MathWorks, Inc.
% August 27, 2004

% Edit the above text to modify the response to help RTviewer

% Last Modified by GUIDE v2.5 19-Aug-2004 16:19:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RTviewer_OpeningFcn, ...
                   'gui_OutputFcn',  @RTviewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RTviewer is made visible.
function RTviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RTviewer (see VARARGIN)

% Choose default command line output for RTviewer
handles.output = hObject;

% Get Ticker
ticker = upper(get(handles.edtTicker,'string'));

% Find today's date
clk = clock; 
todaydate = datenum(clk(1),clk(2),clk(3));
setappdata(gcf,'todaydate',todaydate)

% Create Empty Graph
circs = scatter([],[],'filled');
grid on
title(['Real Time Price Series of ',ticker,', ',datestr(todaydate)])
xlabel('Time')
ylabel('Price ($)')

% Define timer object based on Random Data as default
handles.t = timer('TimerFcn',{@randomRT, ticker},'ExecutionMode', ...
    'fixedRate');

handles.ticker = ticker;

% Pre-define price and time vectors for the data
setappdata(gcf,'bloomprice',[]);
setappdata(gcf,'bloomtime',[]);
setappdata(gcf,'yahooprice',[]);
setappdata(gcf,'yahootime',[]);
setappdata(gcf,'randomprice',[]);
setappdata(gcf,'randomtime',[]);
setappdata(gcf,'circs',circs)

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = RTviewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tglRun.
function tglRun_Callback(hObject, eventdata, handles)
% Start and stop collecting data

% Get booling start of stopping value of toggle button
stopgo = get(hObject,'Value');

% Get period and ticker
period = get(handles.sldPeriod,'value');
ticker = upper(get(handles.edtTicker,'string'));

% Find all timers
alltimers = timerfind;
% Start and stop the timer, but only if it exists
if ~isempty(alltimers) & isfield(handles,'t')
    % Start Viewing Data
    if stopgo
        set(handles.t,'Period',period)
        start(handles.t)
        set(hObject,'string','Stop')
        set(hObject,'BackGroundColor','r')
        set(handles.edtTicker,'enable','off')
    else
        stop(handles.t)
        set(hObject,'BackGroundColor','g')
        set(hObject,'string','Run')
        set(handles.edtTicker,'enable','on')
    end

else
        % Timer doesn't exist, this will force the user to 
    % create one using the other controls
    set(hObject,'string','Run','BackGroundColor','g', ...
        'value',0)
end

%update handles structure
guidata(hObject,handles)

% --- Executes on slider movement.
function sldPeriod_Callback(hObject, eventdata, handles)
% Change updating period via the slider control

% Fetch updating period from the slider
period = get(hObject,'Value');
handles.period = period;

% pass the period defined with the slider to the edit box
set(handles.edtPeriod,'string',num2str(period))

% If the timer is running, it needs to be turned off before
% updating the period
if isfield(handles,'t')
    if isequal(get(handles.t,'Running'),'on')
        % Stop timer
        stop(handles.t)
        
        % change period
        set(handles.t,'Period',period)
        
        % Start it back up
        start(handles.t)
    end
end

% update handles structure
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function sldPeriod_CreateFcn(hObject, eventdata, handles)
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edtPeriod_Callback(hObject, eventdata, handles)
% change the updating period via the edit control

% Fetch period value from the edit box
period = str2double(get(hObject,'String'));

% Set slider period value to period
set(handles.sldPeriod,'value',period)

% if the timer is running, it needs to be turned off before
% updating the period
if isfield(handles,'t')
    if isequal(get(handles.t,'Running'),'on')
        % Stop timer
        stop(handles.t)
        
        % change period
        set(handles.t,'Period',period)
        
        % Start it back up
        start(handles.t)
    end
end

handles.period = period;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edtPeriod_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edtTicker_Callback(hObject, eventdata, handles)

% Delete timer objects
handles = timerconncleanup(handles);

% Clear Plot and Reset Values
dataplotreset(handles.ticker)

% Fetch Parameters
period = get(handles.sldPeriod,'value');
ticker = upper(get(hObject,'string'));

% Find which data source has been selected
btngrpchil = get(handles.btngrpData,'children');
btngprchil = findobj(btngrpchil,'style','radio');
vals = get(btngrpchil,'value');
datasource = find(cell2mat(get(btngrpchil,'value')));

if datasource == 3;  % Bloomberg
    ticker = [ticker,' US Equity'];
    
    % Create and test for valid Bloomberg connection
    try
        handles.Conn = bloomberg;
    catch
        err = errordlg('Invalid Bloomberg Connection');
        set(err,'windowstyle','modal')
        return
    end
    
    % Test if the ticker is valid
    try
        dummy = fetch(handles.Conn,ticker,'GETDATA','Last_Price');
    catch
        err = errordlg('Data fetch failed. Possible invalid ticker.', ...
            'Bloomberg Error','on');
        set(err,'WindowStyle','modal')
        close(handles.Conn)
    return
    end

    % Update Timer Object to use Bloomberg and use new ticker
    handles.t = createtimer(@bloomRT,ticker,period,handles,handles.Conn);
    
elseif datasource == 2
    
    % Create and check for valid Yahoo connection
    try
        handles.Conn = yahoo;
    catch
        err = errordlg('Invalid Yahoo Connection');
        set(err,'windowstyle','modal')
        return
    end
    
    % Test if the ticker is valid
    try
        dummy = fetch(handles.Conn,ticker,'Last');
    catch
        err = errordlg('Data fetch failed. Possible invalid ticker.', ...
            'Yahoo Error','on');
        set(err,'WindowStyle','modal')
        close(handles.Conn)
        return
    end
    
    % update Timer to use Yahoo with new Ticker
    handles.t = createtimer(@yahooRT,ticker,period,handles,handles.Conn);

else
    
    % Update Timer Object with new ticker for the plot
    handles.t = createtimer(@randomRT,ticker,period,handles);
    
end

% Update handles structure
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edtTicker_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in radRandom.
function radRandom_Callback(hObject, eventdata, handles)
% Random Radio Button Callback.
% define timer to use random data

% Turn off existing timer object and delete it
handles = timerconncleanup(handles);

% Clear Plot and Reset Values
dataplotreset(handles.ticker)

% Fetch Parameters
period = get(handles.sldPeriod,'value');
ticker = upper(get(handles.edtTicker,'string'));

handles.t = createtimer(@randomRT,ticker,period,handles);

guidata(hObject,handles)


% --- Executes on button press in radYahoo.
function radYahoo_Callback(hObject, eventdata, handles)
% Yahoo Radio Button Callback.
% Define Timer to use Yahoo data source

% Turn off existing timer object and delete it
handles = timerconncleanup(handles);

% Clear Plot and Reset Values
dataplotreset(handles.ticker)

% Fetch Parameters
period = get(handles.sldPeriod,'value');
ticker = upper(get(handles.edtTicker,'string'));

% Create and check for valid Yahoo connection
try
    handles.Conn = yahoo;
catch
    err = errordlg('Invalid Yahoo Connection');
    set(err,'windowstyle','modal')
    return
end

% Test if the ticker is valid
try
    dummy = fetch(handles.Conn,ticker,'Last');
catch
    err = errordlg('Data fetch failed. Possible invalid ticker.', ...
        'Yahoo Error','on');
    set(err,'WindowStyle','modal')
    close(handles.Conn)
    return
end
    
handles.t = createtimer(@yahooRT,ticker,period,handles,handles.Conn);

guidata(hObject,handles)


% --- Executes on button press in radBloomberg.
function radBloomberg_Callback(hObject, eventdata, handles)
% Bloomberg Radio Button Callback.
% Defind timer to use Bloomberg for a data source

% Turn off existing timer object and delete it
handles = timerconncleanup(handles);

% Clear Plot and Reset Values
dataplotreset(handles.ticker)

% Fetch Parameters
period = get(handles.sldPeriod,'value');
ticker = upper(get(handles.edtTicker,'string'));
ticker = [ticker,' US Equity'];
% Create and test for valid Bloomberg connection
try
    handles.Conn = bloomberg;
catch
    err = errordlg('Invalid Bloomberg Connection');
    set(err,'windowstyle','modal')
    return
end

% Test if the ticker is valid
try
    dummy = fetch(handles.Conn,ticker,'GETDATA','Last_Price');
catch
    err = errordlg('Data fetch failed. Possible invalid ticker.', ...
        'Bloomberg Error','on');
    set(err,'WindowStyle','modal')
    close(handles.Conn)
    return
end
    
% Create New Timer with new TimerFcn, period, and ticker    
handles.t = createtimer(@bloomRT,ticker,period,handles,handles.Conn);
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function randomRT(obj,event,ticker)
% Random Real-Time processing function

% Create Random Price
LastPrice.Last = 100*rand;
TickTime = datenum(event.Data.time);

% Update Price and Time vectors for plotting
Pricevector = [getappdata(gcf,'randomprice'); LastPrice.Last];
setappdata(gcf,'randomprice',Pricevector)
Timevector = [getappdata(gcf,'randomtime'); TickTime];
setappdata(gcf,'randomtime',Timevector)

% Plot the New Data
plotRT(ticker,Pricevector,Timevector)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yahooRT(obj,event,Conn,ticker)
% Yahoo Real-Time processing function

% Fetch price data from Yahoo
LastPrice = fetch(Conn,ticker,'Last');
TickTime = datenum(event.Data.time);

% Update Price and Time vectors for plotting
Pricevector = [getappdata(gcf,'yahooprice'); LastPrice.Last];
setappdata(gcf,'yahooprice',Pricevector)
Timevector = [getappdata(gcf,'yahootime'); TickTime];
setappdata(gcf,'yahootime',Timevector)

% Plot the New Data
plotRT(ticker,Pricevector,Timevector)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bloomRT(obj,event,Conn,ticker)
% Bloomberg Real-Time processing function

% Fetch Price from Bloomberg
LastPrice = fetch(Conn,ticker,'GETDATA','Last_Price');
TickTime = datenum(event.Data.time);

% Update Price and Time vectors for plotting
Pricevector = [getappdata(gcf,'bloomprice'); LastPrice.Last_Price];
setappdata(gcf,'bloomprice',Pricevector)
Timevector = [getappdata(gcf,'bloomtime'); TickTime];
setappdata(gcf,'bloomtime',Timevector)

% Plot the New Data
plotRT(ticker,Pricevector,Timevector)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plotRT(ticker,Pricevector,Timevector)
% General Plotting function for real-time data

% Get handle to the status text box
statusbox = findobj(gcf,'style','text','tag','txtStatus');
circs = getappdata(gcf,'circs');

if length(Pricevector) == 1

    % Plot first Price
    set(circs,'xdata',Timevector,'ydata',Pricevector,'cdata',[0 0 1]);
    setappdata(gcf,'circs',circs);
    axispos = axis;
    set(gca,'xtick',Timevector,'xticklabel',datestr(Timevector,13))

else
    % Test for up or down movement and lable graph points accordingly
    if Pricevector(end) > Pricevector(end-1)
        % update status text box
        set(statusbox,'string','price is higher')
        % Create a green RGB color for the point on the graph
        dotcolor = [0 1 0];
    elseif Pricevector(end) < Pricevector(end-1)
        % update status text box
        set(statusbox,'string','price is lower')
        % Create a red RGB color for this point on the graph
        dotcolor = [1 0 0];
    else
        % update status text box
        set(statusbox,'string','price is unchanged')
        % Create a blue RGB color for this point on the graph
        dotcolor = [0 0 1];
    end
    
    % Fetch current x(time) and y(price) data from the graph
    ctime = get(circs,'xdata');
    cprice = get(circs,'ydata');
    
    % Fetch current colormapping, and update it with the color
    % of the next dot, which was defined above.
    colormat = get(circs,'Cdata');
    colormat = [colormat;dotcolor];
    
    % Update scatter plot with new price point
    set(circs,'xdata',[ctime,Timevector(end)], ...
        'ydata',[cprice, Pricevector(end)],'Cdata',colormat)
    
    % Find and delete line plot so as not to plot too many lines
    dummyline = findobj(gca,'type','line');
    if ~isempty(dummyline)
        delete(dummyline)
    end
    
    % Plot Connecting Line
    plot(Timevector,Pricevector)
    
    % 5 percent of the data range
    x5per = .05*(max(Timevector) - min(Timevector));
    
    % Calculate the lowest and hightest price so far
    lowprice = min(Pricevector);
    highprice = max(Pricevector);
    Range = highprice - lowprice;
    %update axes size for better viewing
    if Range == 0
        axispos = axis;
    else
        axispos = [Timevector(1)-x5per,Timevector(end)+x5per, ...
        max(0,lowprice-Range*.05),highprice+Range*.05];
    end
    
    if length(Timevector) > 2
        % Create appropriate axis viewing range
        axis(axispos)
        datetick('x',13)
    end
end

% Add Title and grid to graph
title(['Real Time Price Series for ', ticker,', ',datestr(Timevector(1),1)])
ylabel('Price (USD)')
grid on
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = timerconncleanup(handles);

delete(hObject);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = timerconncleanup(handles)

alltimers = timerfind;

if ~isempty(alltimers) & isfield(handles,'t')
    if isequal(get(handles.t,'Running'),'on')
        stop(handles.t)
    end
    % use TIMERFIND function to find all timers, and delete them
    delete(alltimers)
    rmfield(handles,'t');
elseif isfield(handles,'t')
    rmfield(handles,'t');
end

if isfield(handles,'Conn')
    close(handles.Conn)
end

set(handles.tglRun,'value',0,'backgroundcolor','g','string','Run')
% guidata(handles.figure1,handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dataplotreset(ticker)

% Get Today's date
todaydate = getappdata(gcf,'todaydate');

reset(gca)
% Create Empty Graph
circs = scatter([],[],'filled');
grid on
title(['Real Time Price Series of ',ticker,', ',datestr(todaydate)])
xlabel('Time')
ylabel('Price ($)')
setappdata(gcf,'circs',circs)

% Data Reset
setappdata(gcf,'bloomprice',[]);
setappdata(gcf,'bloomtime',[]);
setappdata(gcf,'yahooprice',[]);
setappdata(gcf,'yahootime',[]);
setappdata(gcf,'randomprice',[]);
setappdata(gcf,'randomtime',[]);


function tim = createtimer(realtimefun,ticker,period,handles,Conn)
% Create timer object with the datasource defined by the realtimefun
% function handle, and with ticker symbol and update period defined buy
% ticker and period respectiveley.

if nargin == 4
    tim = timer('TimerFcn',{realtimefun, ticker},'ExecutionMode', ...
    'fixedRate', 'Period', period);
else
    % Create timer object with the Yahoo or Bloomberg data source TimerFcn
    tim = timer('TimerFcn',{realtimefun, Conn, ticker},'ExecutionMode', ...
    'fixedRate', 'Period', period);
end