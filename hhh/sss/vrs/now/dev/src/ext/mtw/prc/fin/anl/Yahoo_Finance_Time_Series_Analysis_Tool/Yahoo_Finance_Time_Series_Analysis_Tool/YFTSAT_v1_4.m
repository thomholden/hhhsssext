function varargout = YFTSAT_v1_4(varargin)
% YFTSAT_V1_4 M-file for YFTSAT_v1_4.fig
%      YFTSAT_V1_4, by itself, creates a new YFTSAT_V1_4 or raises the existing
%      singleton*.
%
%      H = YFTSAT_V1_4 returns the handle to a new YFTSAT_V1_4 or the handle to
%      the existing singleton*.
%
%      YFTSAT_V1_4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YFTSAT_V1_4.M with the given input arguments.
%
%      YFTSAT_V1_4('Property','Value',...) creates a new YFTSAT_V1_4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before YFTSAT_v1_4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to YFTSAT_v1_4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help YFTSAT_v1_4

% Last Modified by GUIDE v2.5 19-Jun-2013 10:45:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @YFTSAT_v1_4_OpeningFcn, ...
                   'gui_OutputFcn',  @YFTSAT_v1_4_OutputFcn, ...
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


% --- Executes just before YFTSAT_v1_4 is made visible.
function YFTSAT_v1_4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to YFTSAT_v1_4 (see VARARGIN)

% set end date to yesterday
set(handles.DayEnd, 'String', day(today - 1));
set(handles.MonthEnd, 'String', month(today - 1));
set(handles.YearEnd, 'String', year(today - 1));

% set start date to yesterday of last year
set(handles.DayStart, 'String', day(today - 1));
set(handles.MonthStart, 'String', month(today - 1));
set(handles.YearStart, 'String', year(today - 365));

% Choose default command line output for YFTSAT_v1_4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes YFTSAT_v1_4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = YFTSAT_v1_4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function TickerSymbol_Callback(hObject, eventdata, handles)
% hObject    handle to TickerSymbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TickerSymbol as text
%        str2double(get(hObject,'String')) returns contents of TickerSymbol as a double


% --- Executes during object creation, after setting all properties.
function TickerSymbol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TickerSymbol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DayStart_Callback(hObject, eventdata, handles)
% hObject    handle to DayStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DayStart as text
%        str2double(get(hObject,'String')) returns contents of DayStart as a double


% --- Executes during object creation, after setting all properties.
function DayStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DayStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MonthStart_Callback(hObject, eventdata, handles)
% hObject    handle to MonthStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MonthStart as text
%        str2double(get(hObject,'String')) returns contents of MonthStart as a double


% --- Executes during object creation, after setting all properties.
function MonthStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MonthStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MonthEnd_Callback(hObject, eventdata, handles)
% hObject    handle to MonthEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MonthEnd as text
%        str2double(get(hObject,'String')) returns contents of MonthEnd as a double


% --- Executes during object creation, after setting all properties.
function MonthEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MonthEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YearStart_Callback(hObject, eventdata, handles)
% hObject    handle to MonthEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MonthEnd as text
%        str2double(get(hObject,'String')) returns contents of MonthEnd as a double


% --- Executes during object creation, after setting all properties.
function YearStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MonthEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DayEnd_Callback(hObject, eventdata, handles)
% hObject    handle to MonthEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MonthEnd as text
%        str2double(get(hObject,'String')) returns contents of MonthEnd as a double


% --- Executes during object creation, after setting all properties.
function DayEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MonthEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YearEnd_Callback(hObject, eventdata, handles)
% hObject    handle to YearEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YearEnd as text
%        str2double(get(hObject,'String')) returns contents of YearEnd as a double


% --- Executes during object creation, after setting all properties.
function YearEnd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YearEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in ButtonPriceVariable.
function ButtonPriceVariable_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonPriceVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonPriceVariable


% --- Executes on button press in ButtonSReturnVariable.
function ButtonSReturnVariable_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSReturnVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonSReturnVariable


% --- Executes on button press in ButtonLReturnVariable.
function ButtonLReturnVariable_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonLReturnVariable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonLReturnVariable


% --- Executes on selection change in PricesSelect.
function PricesSelect_Callback(hObject, eventdata, handles)
% hObject    handle to PricesSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PricesSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PricesSelect


% --- Executes during object creation, after setting all properties.
function PricesSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PricesSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonMean.
function ButtonMean_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonMean


% --- Executes on button press in ButtonMedian.
function ButtonMedian_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonMedian (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonMedian


% --- Executes on button press in ButtonMin.
function ButtonMin_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonMin


% --- Executes on button press in ButtonMax.
function ButtonMax_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonMax


% --- Executes on button press in ButtonRange.
function ButtonRange_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonRange


% --- Executes on button press in ButtonVar.
function ButtonVar_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonVar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonVar


% --- Executes on button press in ButtonStDev.
function ButtonStDev_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonStDev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonStDev


% --- Executes on button press in ButtonVola.
function ButtonVola_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonVola (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonVola


% --- Executes on button press in ButtonSkew.
function ButtonSkew_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSkew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonSkew


% --- Executes on button press in ButtonKurt.
function ButtonKurt_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonKurt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonKurt


% --- Executes on button press in ButtonPercentiles.
function ButtonPercentiles_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonPercentiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonPercentiles


% --- Executes on button press in ButtonUPercentile.
function ButtonUPercentile_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonUPercentile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Enable Inputfield when User Percentile checkbox = 1
if get(handles.ButtonUPercentile, 'Value') == 1, set(handles.UPercentileInput, 'Enable', 'on'); end;
if get(handles.ButtonUPercentile, 'Value') == 0, set(handles.UPercentileInput, 'Enable', 'off'); set(handles.UPercentileInput, 'String', '');end;

% Hint: get(hObject,'Value') returns toggle state of ButtonUPercentile



function UPercentileInput_Callback(hObject, eventdata, handles)
% hObject    handle to UPercentileInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UPercentileInput as text
%        str2double(get(hObject,'String')) returns contents of UPercentileInput as a double


% --- Executes during object creation, after setting all properties.
function UPercentileInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UPercentileInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonPriceGraph.
function ButtonPriceGraph_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonPriceGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonPriceGraph


% --- Executes on button press in ButtonSReturnGraph.
function ButtonSReturnGraph_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonSReturnGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonSReturnGraph


% --- Executes on button press in ButtonLReturnGraph.
function ButtonLReturnGraph_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonLReturnGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ButtonLReturnGraph


% --- Executes on button press in ButtonHistogram.
function ButtonHistogram_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonHistogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clear Bin Inputbox and disable when checkbox is unchecked, 
if get(handles.ButtonHistogram, 'Value') == 0, set(handles.BinsInput, 'Enable', 'off'); set(handles.BinsInput, 'String', '');end;
if get(handles.ButtonHistogram, 'Value') == 1, set(handles.BinsInput, 'Enable', 'on'); end;

% Hint: get(hObject,'Value') returns toggle state of ButtonHistogram



function BinsInput_Callback(hObject, eventdata, handles)
% hObject    handle to BinsInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BinsInput as text
%        str2double(get(hObject,'String')) returns contents of BinsInput as a double


% --- Executes during object creation, after setting all properties.
function BinsInput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinsInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonStart.
function ButtonStart_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set the time interval variable according to active radio button
if get(handles.ButtonDaily, 'Value')==1 , TimeInterval='d' ; end;
if get(handles.ButtonWeekly, 'Value')==1 , TimeInterval='w' ; end;
if get(handles.ButtonMonthly, 'Value')==1 , TimeInterval='m' ; end

% Set the price category
if get(handles.PricesSelect, 'Value')==1 , PriceCategory=1; end;
if get(handles.PricesSelect, 'Value')==2 , PriceCategory=2; end;
if get(handles.PricesSelect, 'Value')==3 , PriceCategory=3; end;
if get(handles.PricesSelect, 'Value')==4 , PriceCategory=4; end;
if get(handles.PricesSelect, 'Value')==5 , PriceCategory=6; end;
    
% Download CSV file from finance.yahoo.com and save it to the current folder, then import it as a variable
urlwrite(['http://ichart.finance.yahoo.com/table.csv?s=' , get(handles.TickerSymbol, 'String') , '&a=' , get(handles.MonthStart, 'String') , '&b=' , get(handles.DayStart, 'String') , '&c=' , get(handles.YearStart, 'String') , '&d=' , get(handles.MonthEnd, 'String') , '&e=' , get(handles.DayEnd, 'String') , '&f=' , get(handles.YearEnd, 'String') , '&g=' , TimeInterval , '&ignore=.csv'],'table.csv');
csvimport = importdata('table.csv');

% Delete the first row of the textdata (the data labels) and flip the matrices upside down (from oldest to newest)
csvimport.textdata = csvimport.textdata(~ismember(1:size(csvimport.textdata, 1), 1), :);
csvimport.data = flipud(csvimport.data);
csvimport.textdata = flipud(csvimport.textdata);

% Send the variable to the workspace
assignin('base', 'csvimport', csvimport);

% Check if User Percentile input is valid
% if get(handles.ButtonUPercentile, 'Value')==1 && get(handles.UPercentileInput, 'String')=='', set(handles.ButtonUPercentile, 'Value', 0); end;

% Create empty variable containers
StatsSimpleReturns = [] ;
StatsLogReturns = [] ;
VaRSimpleReturns = [] ;
VaRLogReturns = [] ;

% Create Price Series Variable if checked and send variable to workspace
if get(handles.ButtonPriceVariable, 'Value')==1 , PriceSeries = csvimport.data(:, PriceCategory) ; assignin('base', 'PriceSeries', PriceSeries); end;

% Create Simple Returns Variable if checked and send variable to workspace
if get(handles.ButtonSReturnVariable, 'Value')==1 , SimpleReturns = tick2ret(csvimport.data(:, PriceCategory)) ; assignin('base', 'SimpleReturns', SimpleReturns); end;

% Create Log Returns Variable if checked and send variable to workspace
if get(handles.ButtonLReturnVariable, 'Value')==1 , LogReturns = price2ret(csvimport.data(:, PriceCategory)) ; assignin('base', 'LogReturns', LogReturns); end;

% Create Mean Variables if checked
if get(handles.ButtonMean, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'Mean',mean(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonMean, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'Mean',mean(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Median Variables if checked
if get(handles.ButtonMedian, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'Median',median(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonMedian, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'Median',median(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Minimum Variables if checked
if get(handles.ButtonMin, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'Minimum',min(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonMin, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'Minimum',min(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Maximum Variables if checked
if get(handles.ButtonMax, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'Maximum',max(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonMax, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'Maximum',max(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Range Variables if checked
if get(handles.ButtonRange, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'Range',range(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonRange, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'Range',range(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Variance Variables if checked
if get(handles.ButtonVar, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'Variance',var(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonVar, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'Variance',var(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Standard Deviation Variables if checked
if get(handles.ButtonStDev, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'StandardDeviation',std(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonStDev, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'StandardDeviation',std(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Volatility Variables if checked
if get(handles.ButtonVola, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1
    if TimeInterval == 'd'
        StatsSimpleReturns = setfield(StatsSimpleReturns,'AnnualizedVolatility',sqrt(252) * std(tick2ret(csvimport.data(:, PriceCategory)))); 
    elseif TimeInterval == 'w'
        StatsSimpleReturns = setfield(StatsSimpleReturns,'AnnualizedVolatility',sqrt(52) * std(tick2ret(csvimport.data(:, PriceCategory))));
    else
        StatsSimpleReturns = setfield(StatsSimpleReturns,'AnnualizedVolatility',sqrt(12) * std(tick2ret(csvimport.data(:, PriceCategory))));
    end
end;

if get(handles.ButtonVola, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1
    if TimeInterval == 'd'
        StatsLogReturns = setfield(StatsLogReturns,'AnnualizedVolatility',sqrt(252) * std(price2ret(csvimport.data(:, PriceCategory)))); 
    elseif TimeInterval == 'w'
        StatsLogReturns = setfield(StatsLogReturns,'AnnualizedVolatility',sqrt(52) * std(price2ret(csvimport.data(:, PriceCategory))));
    else
        StatsLogReturns = setfield(StatsLogReturns,'AnnualizedVolatility',sqrt(12) * std(price2ret(csvimport.data(:, PriceCategory))));
    end
end;


% Create Skewness Variables if checked
if get(handles.ButtonSkew, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'Skewness',skewness(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonSkew, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'Skewness',skewness(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Kurtosis Variables if checked
if get(handles.ButtonKurt, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, StatsSimpleReturns = setfield(StatsSimpleReturns,'Kurtosis',kurtosis(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonKurt, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, StatsLogReturns = setfield(StatsLogReturns,'Kurtosis',kurtosis(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Parametric Gaussian VaR Variables if checked
if get(handles.ButtonParametricVaR, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, VaRSimpleReturns = setfield(VaRSimpleReturns,'ParametricGaussianVaR',mean(tick2ret(csvimport.data(:, PriceCategory)))+norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1)*std(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonParametricVaR, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, VaRLogReturns = setfield(VaRLogReturns,'ParametricGaussianVaR',mean(price2ret(csvimport.data(:, PriceCategory)))+norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1)*std(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Cornish Fisher VaR Variables if checked
if get(handles.ButtonCornishFisherVaR, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, VaRSimpleReturns = setfield(VaRSimpleReturns,'CornishFisherVaR',mean(tick2ret(csvimport.data(:, PriceCategory)))+((norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1))+1/6*((norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1))^2-1)*skewness(tick2ret(csvimport.data(:, PriceCategory)))+1/24*((norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1))^3-3*(norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1)))*kurtosis(tick2ret(csvimport.data(:, PriceCategory)))-1/36*(2*((norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1)))^3-5*(norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1)))*(skewness(tick2ret(csvimport.data(:, PriceCategory))))^2)*std(tick2ret(csvimport.data(:, PriceCategory)))); end;
if get(handles.ButtonCornishFisherVaR, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, VaRLogReturns = setfield(VaRLogReturns,'CornishFisherVaR',mean(price2ret(csvimport.data(:, PriceCategory)))+((norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1))+1/6*((norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1))^2-1)*skewness(price2ret(csvimport.data(:, PriceCategory)))+1/24*((norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1))^3-3*(norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1)))*kurtosis(price2ret(csvimport.data(:, PriceCategory)))-1/36*(2*((norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1)))^3-5*(norminv((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100,0,1)))*(skewness(price2ret(csvimport.data(:, PriceCategory))))^2)*std(price2ret(csvimport.data(:, PriceCategory)))); end;

% Create Historical Equal Weight VaR Variables if checked
if get(handles.ButtonHistoricalVaR, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, VaRSimpleReturns = setfield(VaRSimpleReturns,'HistoricalEqualWeightVaR',prctile(tick2ret(csvimport.data(:, PriceCategory)),(100-(str2double(get(handles.VaRConfidenceLevel, 'String')))))); end;
if get(handles.ButtonHistoricalVaR, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, VaRLogReturns = setfield(VaRLogReturns,'HistoricalEqualweightVaR',prctile(price2ret(csvimport.data(:, PriceCategory)),(100-(str2double(get(handles.VaRConfidenceLevel, 'String')))))); end;

% Create Historical EWMA VaR Variables if checked
if get(handles.ButtonEWMAVaR, 'Value')==1 && get(handles.ButtonSReturnVariable, 'Value')==1, 
    
    i = 1; j = 0;    
    lambda = str2double(get(handles.LambdaEWMAVaR, 'String'));
    for i = 0:(numel(SimpleReturns)-1);
    j = lambda^i;
    if i == 0, j=1; end;
    EWMAWeights(i+1,1)= ((1-lambda)/(1-(lambda^numel(SimpleReturns))))*j;
    end

    EWMAWeights(:,2)=flipud(SimpleReturns);
    EWMAWeights = sortrows(EWMAWeights, 2);

    i = 1; j = 0;

    for i = 1:numel(SimpleReturns);
        j = j + EWMAWeights(i,1);
    if j > (100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100, break; end;
    end;
    VaRSimpleReturns = setfield(VaRSimpleReturns,'HistoricalEWMAVaR',EWMAWeights(i-1,2)+(EWMAWeights(i,2)-EWMAWeights(i-1,2))*((((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100)-EWMAWeights(i-1,1))/(EWMAWeights(i,1)-EWMAWeights(i-1,1)))); 
end;


if get(handles.ButtonEWMAVaR, 'Value')==1 && get(handles.ButtonLReturnVariable, 'Value')==1, 
    
    i = 1; j = 0;    
    lambda = str2double(get(handles.LambdaEWMAVaR, 'String'));
    EWMAWeights = NaN;
    for i = 0:(numel(LogReturns)-1);
    j = lambda^i;
    if i == 0, j=1; end;
    EWMAWeights(i+1,1)= ((1-lambda)/(1-(lambda^numel(LogReturns))))*j;
    end

    EWMAWeights(:,2)=flipud(LogReturns);
    EWMAWeights = sortrows(EWMAWeights, 2);

    i = 1; j = 0;

    for i = 1:numel(LogReturns);
        j = j + EWMAWeights(i,1);
    if j > (100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100, break; end;
    end;    
    VaRLogReturns = setfield(VaRLogReturns,'HistoricalEWMAVaR',EWMAWeights(i-1,2)+(EWMAWeights(i,2)-EWMAWeights(i-1,2))*((((100-(str2double(get(handles.VaRConfidenceLevel, 'String'))))/100)-EWMAWeights(i-1,1))/(EWMAWeights(i,1)-EWMAWeights(i-1,1))));
end;


% Send Stats Variables to workspace if any Stat checkbox is checked
if get(handles.ButtonSReturnVariable, 'Value')==1, 
    assignin('base', 'StatsSimpleReturns', StatsSimpleReturns); 
    assignin('base', 'VaRSimpleReturns', VaRSimpleReturns);
end;
if get(handles.ButtonLReturnVariable, 'Value')==1, 
    assignin('base', 'StatsLogReturns', StatsLogReturns); 
    assignin('base', 'VaRLogReturns', VaRLogReturns); 
end;


% Save selected plots
if get(handles.ButtonPriceGraph, 'Value')==1, figure('Visible','Off'); saveas(plot(datenum(csvimport.textdata( : , 1)) , csvimport.data( : , PriceCategory)),'PriceSeriesPlot','png'); datetick( 'x' , 'mm-yyyy' ); end;

if get(handles.ButtonSReturnGraph, 'Value')==1, figure('Visible','Off'); saveas(plot(datenum(csvimport.textdata( 2:end , 1)) , tick2ret(csvimport.data( : , PriceCategory))),'SimpleReturnPlot','png'); datetick( 'x' , 'mm-yyyy' ); end;
if get(handles.ButtonLReturnGraph, 'Value')==1, figure('Visible','Off'); saveas(plot(datenum(csvimport.textdata( 2:end , 1)) , price2ret(csvimport.data( : , PriceCategory))),'LogReturnPlot','png'); datetick( 'x' , 'mm-yyyy' ); end;

if get(handles.ButtonHistogram, 'Value')==1, f = figure('Visible','Off'); hist(tick2ret(csvimport.data( : , PriceCategory)), str2double(get(handles.BinsInput, 'String'))) ;saveas(f,'HistogramSimpleReturn','png'); end;


% --- Executes on button press in ButtonParametricVaR.
function ButtonParametricVaR_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonParametricVaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.ButtonParametricVaR, 'Value') == 0 && get(handles.ButtonCornishFisherVaR, 'Value') == 0 && get(handles.ButtonHistoricalVaR, 'Value') == 0 && get(handles.ButtonEWMAVaR, 'Value') == 0 && get(handles.ButtonCAViaR, 'Value') == 0, set(handles.VaRConfidenceLevel, 'Enable', 'off'); set(handles.VaRConfidenceLevel, 'String', '');end;
if get(handles.ButtonParametricVaR, 'Value') == 1, set(handles.VaRConfidenceLevel, 'Enable', 'on'); end;

% Hint: get(hObject,'Value') returns toggle state of ButtonParametricVaR


% --- Executes on button press in ButtonCornishFisherVaR.
function ButtonCornishFisherVaR_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCornishFisherVaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.ButtonParametricVaR, 'Value') == 0 && get(handles.ButtonCornishFisherVaR, 'Value') == 0 && get(handles.ButtonHistoricalVaR, 'Value') == 0 && get(handles.ButtonEWMAVaR, 'Value') == 0 && get(handles.ButtonCAViaR, 'Value') == 0, set(handles.VaRConfidenceLevel, 'Enable', 'off'); set(handles.VaRConfidenceLevel, 'String', '');end;
if get(handles.ButtonCornishFisherVaR, 'Value') == 1, set(handles.VaRConfidenceLevel, 'Enable', 'on'); end;

% Hint: get(hObject,'Value') returns toggle state of ButtonCornishFisherVaR


% --- Executes on button press in ButtonHistoricalVaR.
function ButtonHistoricalVaR_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonHistoricalVaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.ButtonParametricVaR, 'Value') == 0 && get(handles.ButtonCornishFisherVaR, 'Value') == 0 && get(handles.ButtonHistoricalVaR, 'Value') == 0 && get(handles.ButtonEWMAVaR, 'Value') == 0 && get(handles.ButtonCAViaR, 'Value') == 0, set(handles.VaRConfidenceLevel, 'Enable', 'off'); set(handles.VaRConfidenceLevel, 'String', '');end;
if get(handles.ButtonHistoricalVaR, 'Value') == 1, set(handles.VaRConfidenceLevel, 'Enable', 'on'); end;

% Hint: get(hObject,'Value') returns toggle state of ButtonHistoricalVaR


% --- Executes on button press in ButtonEWMAVaR.
function ButtonEWMAVaR_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonEWMAVaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.ButtonParametricVaR, 'Value') == 0 && get(handles.ButtonCornishFisherVaR, 'Value') == 0 && get(handles.ButtonHistoricalVaR, 'Value') == 0 && get(handles.ButtonEWMAVaR, 'Value') == 0 && get(handles.ButtonCAViaR, 'Value') == 0, set(handles.VaRConfidenceLevel, 'Enable', 'off'); set(handles.VaRConfidenceLevel, 'String', '');end;
if get(handles.ButtonEWMAVaR, 'Value') == 1, set(handles.VaRConfidenceLevel, 'Enable', 'on'), set(handles.LambdaEWMAVaR, 'Enable', 'on'); end;
if get(handles.ButtonEWMAVaR, 'Value') == 0, set(handles.LambdaEWMAVaR, 'Enable', 'off'); set(handles.LambdaEWMAVaR, 'String', '');end;


% Hint: get(hObject,'Value') returns toggle state of ButtonEWMAVaR


% --- Executes on button press in ButtonCAViaR.
function ButtonCAViaR_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonCAViaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.ButtonParametricVaR, 'Value') == 0 && get(handles.ButtonCornishFisherVaR, 'Value') == 0 && get(handles.ButtonHistoricalVaR, 'Value') == 0 && get(handles.ButtonEWMAVaR, 'Value') == 0 && get(handles.ButtonCAViaR, 'Value') == 0, set(handles.VaRConfidenceLevel, 'Enable', 'off'); set(handles.VaRConfidenceLevel, 'String', '');end;
if get(handles.ButtonCAViaR, 'Value') == 1, set(handles.VaRConfidenceLevel, 'Enable', 'on'); end;

% Hint: get(hObject,'Value') returns toggle state of ButtonCAViaR



function VaRConfidenceLevel_Callback(hObject, eventdata, handles)
% hObject    handle to VaRConfidenceLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VaRConfidenceLevel as text
%        str2double(get(hObject,'String')) returns contents of VaRConfidenceLevel as a double


% --- Executes during object creation, after setting all properties.
function VaRConfidenceLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VaRConfidenceLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function LambdaEWMAVaR_Callback(hObject, eventdata, handles)
% hObject    handle to LambdaEWMAVaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LambdaEWMAVaR as text
%        str2double(get(hObject,'String')) returns contents of LambdaEWMAVaR as a double


% --- Executes during object creation, after setting all properties.
function LambdaEWMAVaR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LambdaEWMAVaR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
