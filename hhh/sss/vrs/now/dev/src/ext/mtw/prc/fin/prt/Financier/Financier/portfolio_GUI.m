
function varargout = portfolio_GUI(varargin)
% PORTFOLIO_GUI M-file for portfolio_GUI.fig
%      PORTFOLIO_GUI, by itself, creates a new PORTFOLIO_GUI or raises the existing
%      singleton*.
%
%      H = PORTFOLIO_GUI returns the handle to a new PORTFOLIO_GUI or the handle to
%      the existing singleton*.
%
%      PORTFOLIO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PORTFOLIO_GUI.M with the given input arguments.
%
%      PORTFOLIO_GUI('Property','Value',...) creates a new PORTFOLIO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before portfolio_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to portfolio_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help portfolio_GUI

% Last Modified by GUIDE v2.5 26-Oct-2014 19:38:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @portfolio_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @portfolio_GUI_OutputFcn, ...
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


% --- Executes just before portfolio_GUI is made visible.

function axes30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
axes(hObject)

imshow('Logo.jpeg')

function axes31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes31

axes(hObject)

imshow('flute.jpeg')
function portfolio_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to portfolio_GUI (see VARARGIN)




bgcolor = [0 0 0];
set(hObject, 'Color', bgcolor);
set(findobj(hObject,'-property', 'BackgroundColor'), 'BackgroundColor', bgcolor);



time_from=get(handles.time_from,'string');
time_to=get(handles.time_to,'string');




% Capital 
ma1=str2num(get(handles.ma1,'string'));
ma2=str2num(get(handles.ma2,'string'));
ma3=str2num(get(handles.ma3,'string'));
ma4=str2num(get(handles.ma4,'string'));
ma5=str2num(get(handles.ma5,'string'));
ma6=str2num(get(handles.ma6,'string'));
ma7=str2num(get(handles.ma7,'string'));



Capital=ma1+ma2+ma3+ma4+ma5+ma6+ma7;

%Display the initial Capital 


set(handles.initial_capital,'string',Capital);

% indices

m1=get(handles.m1,'string');
m2=get(handles.m2,'string');
m3=get(handles.m3,'string');
m4=get(handles.m4,'string');
m5=get(handles.m5,'string');
m6=get(handles.m6,'string');
m7=get(handles.m7,'string');



set(handles.s1,'string',m1);
set(handles.s2,'string',m2);
set(handles.s3,'string',m3);
set(handles.s4,'string',m4);
set(handles.s5,'string',m5);
set(handles.s6,'string',m6);
set(handles.s7,'string',m7);


temp_symbols = {m1,m2,m3,m4,m5,m6,m7};



j=1;
for i=1:length(temp_symbols);
    if char(temp_symbols(1,i))~'';
       symbols(j)=temp_symbols(i);
       j=j+1;
    end
end
        



[y, dates] = get_yahoo_data(symbols,time_from,time_to);


%2- How many index? 
quantity=size(symbols,2);

X=y(:,:);



%% Tracking process 

%Capital Matrix: 
Cap=zeros(1,quantity);  

Cap(1,1)=ma1;
Cap(1,2)=ma2;
Cap(1,3)=ma3;
Cap(1,4)=ma4;







n=1;
while n<=quantity 
    
   %fitting a line to the data for each index.  
   fit=polyfit(1:length(X(:,n)),transpose(X(:,n)),1);
   
   %selecting out the slope from the fit data:
   m(1,n)=fit(1);
    
 
          n=n+1;
          
 end 

 %% Allocation process:
   %Normalization: sum of alpha*(1/m(1,i))=1
   
     su=0;
for w=1:quantity;
   su=su+1/m(1,w);
end
alpha=1/su;
   
   %Final allocation:
for t=1:quantity; 
    Cap(1,t)=Capital*(1/m(1,t))*alpha;
end



%% normalize prices
L = length(X);

Xnorm = X./repmat(X(1,:),L,1);



%%Plugging in the Portfolio Optimization results here.


for n=1:quantity
 
    shares(1,n) = [Cap(1,n)/X(1,n)];

end


value = X.*repmat(shares,L,1);

days=length(value);

portfolio = sum(value,2);



%The allocation results


%Fit to portfolio to get interest rate

fit_portfolio=polyfit(1:length(portfolio),transpose(portfolio(:,:)),1);

%Calculate the best fit to the simulation interest rate
IR=(5/7)*365*fit_portfolio(1,1)/portfolio(1,1); % 5/7 is to adjust for Business days 
Final_Value=portfolio(size(portfolio,1));
Profit=Final_Value-Capital;

res=num2cell(zeros(2,size(symbols,2)));
res(1,:)=symbols;
res(2,:)=num2cell(Cap);
results=transpose(res);


%Displaying the Final Value:

set(handles.final,'string',Final_Value);


%Displaying the suggested allocation 

display_results=zeros(length(Cap),1);

j=1;
for i=1:length(temp_symbols);
    if char(temp_symbols(1,i))~'';
       display_results(j)=Cap(i);
       
       j=j+1;
       else
         display_results(i)=0;
        
    end
end



set(handles.sa1,'string',display_results(1));
set(handles.sa2,'string',display_results(2));
set(handles.sa3,'string',display_results(3));
set(handles.sa4,'string',display_results(4));
set(handles.sa5,'string',display_results(5));
set(handles.sa6,'string',display_results(6));
set(handles.sa7,'string',display_results(7));


%% Let the plotting begin


% axes1
colordef black
%Figure 1:
plot(handles.axes1,Xnorm,'--');
legend(handles.axes1,symbols);
set(gcf,'Color','k')
set(gca,'color','k')


savings=zeros(size(portfolio,1),1);
savings(1)=portfolio(1);

i=1;
while i<size(portfolio,1);
    i=i+1;
savings(i)=savings(i-1)*(0.012/(365*(5/7)))+savings(i-1);
end


%%2 To plot the fit to the portfolio
fixed_portfolio=zeros(size(portfolio,1),1);
fixed_portfolio(1)=portfolio(1);

i=1;
while i<size(portfolio,1)
    i=i+1;
fixed_portfolio(i)=fixed_portfolio(i-1)*(IR/(365*(5/7)))+fixed_portfolio(i-1);
end


%%%%%%
%portfolio_savings=zeros(size(savings,1),3);
%portfolio_savings(:,1)=portfolio(:,1);                       Garbage
%portfolio_savings(:,2)=savings(:,1);
%portfolio_savings(:,3)=fixed_portfolio(:,1);
%%%%%

index = [1:length(portfolio)]';



%% Manual


%2- How many index? 
manual_quantity=size(symbols,2);

X=y(:,:);


%Capital Matrix: 
manual_Cap=zeros(1,manual_quantity);  

for c=1:manual_quantity
manual_Cap(c)=25e3;
end




 %% Manual Allocation:
 
 
 
%% normalize prices
L = length(X);

Xnorm = X./repmat(X(1,:),L,1);



%%Plugging in the Portfolio Optimization results here.


for n=1:quantity
 
    manual_shares(1,n) = [manual_Cap(1,n)/X(1,n)];

end


manual_value = X.*repmat(manual_shares,L,1);

days=length(value);

manual_portfolio = sum(manual_value,2);



%The allocation results


%Fit to portfolio to get interest rate

fit_manual_portfolio=polyfit(1:length(manual_portfolio),transpose(manual_portfolio(:,:)),1);

%Calculate the best fit to the simulation interest rate
manual_IR=(5/7)*365*fit_manual_portfolio(1,1)/manual_portfolio(1,1); % 5/7 is to adjust for Business days 
Final_Manual_Value=manual_portfolio(size(manual_portfolio,1));
Manual_Profit=Final_Manual_Value-Capital;

manual_res=num2cell(zeros(2,size(symbols,2)));
manual_res(1,:)=symbols;
manual_res(2,:)=num2cell(manual_Cap);
manual_results=transpose(manual_res);


%Displaying the Final Value:

set(handles.manual_final,'string',Final_Manual_Value);




%%2 To plot the fit to the portfolio
fixed_manual_portfolio=zeros(size(manual_portfolio,1),1);
fixed_manual_portfolio(1)=manual_portfolio(1);


i=1;
while i<size(manual_portfolio,1);
    i=i+1;
fixed_manual_portfolio(i)=fixed_manual_portfolio(i-1)*(manual_IR/(365*(5/7)))+fixed_manual_portfolio(i-1);
end




colordef black
%Figure 2: 
plot(handles.axes2,index,(portfolio),'w-',index,(manual_portfolio),'c-'),grid;
legend(handles.axes2,'Simulation ',['Sim. Annual Gain : ',num2str(round(IR*1000)/10) ,'%'],'Market Value ',['Manual Annual Gain : ',num2str(round(manual_IR*1000)/10) ,'%']);


colordef black
%Figure 3: 
plot(handles.axes3,index,(manual_portfolio),'c-'),grid;
legend(handles.axes3,'Market Value',['Manual Annual Gain : ',num2str(round(manual_IR*1000)/10) ,'%']);




% Choose default command line output for portfolio_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes portfolio_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = portfolio_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Capital_Callback(hObject, eventdata, handles)
% hObject    handle to Capital (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Capital as text
%        str2double(get(hObject,'String')) returns contents of Capital as a double





% --- Executes during object creation, after setting all properties.
function Capital_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Capital (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_from_Callback(hObject, eventdata, handles)
% hObject    handle to time_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_from as text
%        str2double(get(hObject,'String')) returns contents of time_from as a double


% --- Executes during object creation, after setting all properties.
function time_from_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_from (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_to_Callback(hObject, eventdata, handles)
% hObject    handle to time_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_to as text
%        str2double(get(hObject,'String')) returns contents of time_to as a double


% --- Executes during object creation, after setting all properties.
function time_to_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_to (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when entered data in editable cell(s) in Manual.
function Manual_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Manual (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)






%% Run Botton
% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes during object creation, after setting all properties.
function final_CreateFcn(hObject, eventdata, handles)
% hObject    handle to final (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function enter_index_Callback(hObject, eventdata, handles)
% hObject    handle to enter_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_index as text
%        str2double(get(hObject,'String')) returns contents of enter_index as a double


% --- Executes during object creation, after setting all properties.
function enter_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enter_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function enter_amount_Callback(hObject, eventdata, handles)
% hObject    handle to enter_amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter_amount as text
%        str2double(get(hObject,'String')) returns contents of enter_amount as a double


% --- Executes during object creation, after setting all properties.
function enter_amount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enter_amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function remove_amount_Callback(hObject, eventdata, handles)
% hObject    handle to remove_amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of remove_amount as text
%        str2double(get(hObject,'String')) returns contents of remove_amount as a double


% --- Executes during object creation, after setting all properties.
function remove_amount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_amount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in remove.
function remove_Callback(hObject, eventdata, handles)
% hObject    handle to remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function remove_index_Callback(hObject, eventdata, handles)
% hObject    handle to remove_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of remove_index as text
%        str2double(get(hObject,'String')) returns contents of remove_index as a double


% --- Executes during object creation, after setting all properties.
function remove_index_CreateFcn(hObject, eventdata, handles)
% hObject    handle to remove_index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Run Botton
% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




time_from=get(handles.time_from,'string');
time_to=get(handles.time_to,'string');



ma=zeros(1,7);

% Capital 
ma(1)=str2num(get(handles.ma1,'string'));
ma(2)=str2num(get(handles.ma2,'string'));
ma(3)=str2num(get(handles.ma3,'string'));
ma(4)=str2num(get(handles.ma4,'string'));
ma(5)=str2num(get(handles.ma5,'string'));
ma(6)=str2num(get(handles.ma6,'string'));
ma(7)=str2num(get(handles.ma7,'string'));



Capital=sum(ma);

%Display the initial Capital 


set(handles.initial_capital,'string',Capital);

% indices

m1=get(handles.m1,'string');
m2=get(handles.m2,'string');
m3=get(handles.m3,'string');
m4=get(handles.m4,'string');
m5=get(handles.m5,'string');
m6=get(handles.m6,'string');
m7=get(handles.m7,'string');



set(handles.s1,'string',m1);
set(handles.s2,'string',m2);
set(handles.s3,'string',m3);
set(handles.s4,'string',m4);
set(handles.s5,'string',m5);
set(handles.s6,'string',m6);
set(handles.s7,'string',m7);



temp_symbols = {m1,m2,m3,m4,m5,m6,m7};



j=1;
for i=1:length(temp_symbols);
    if char(temp_symbols(1,i))~'';
       symbols(j)=temp_symbols(i);
       j=j+1;
    end
end


[y, dates] = get_yahoo_data(symbols,time_from,time_to);



%2- How many index? 
manual_quantity=size(symbols,2);

%Manual Capital Matrix: 
manual_Cap=zeros(manual_quantity,1);  


j=1;
for i=1:length(temp_symbols);
    if ma(i)~0;
       manual_Cap(j)=ma(i);
       j=j+1;
    end
end
        



%%x Cut to get rid of non-available data (i.e NAN)

X=y(:,:);


n=1;
while n<=manual_quantity 
    
   %fitting a line to the data for each index.  
   fit=polyfit(1:length(X(:,n)),transpose(X(:,n)),1);
   
   %selecting out the slope from the fit data:
   m(1,n)=fit(1);
    
 
          n=n+1;
          
          
          
 end 

 %% Allocation process:
   %Normalization: sum of alpha*(1/m(1,i))=1
   
   
     su=0;
for w=1:manual_quantity;
   su=su+1/m(1,w);
end
alpha=1/su;
   
   %Final allocation:
for t=1:manual_quantity; 
    Cap(1,t)=Capital*(1/m(1,t))*alpha;
end




%Displaying the suggested allocation 

display_results=zeros(length(Cap),1);

j=1;
for i=1:length(temp_symbols);
    if char(temp_symbols(1,i))~'';
       display_results(j)=Cap(i);
       
       j=j+1;
       else
         display_results(i)=0;
        
    end
end



set(handles.sa1,'string',display_results(1));
set(handles.sa2,'string',display_results(2));
set(handles.sa3,'string',display_results(3));
set(handles.sa4,'string',display_results(4));
set(handles.sa5,'string',display_results(5));
set(handles.sa6,'string',display_results(6));
set(handles.sa7,'string',display_results(7));


%% normalize prices
L = length(X);

Xnorm = X./repmat(X(1,:),L,1);



%%Plugging in the Portfolio Optimization results here.


for n=1:manual_quantity
 
    shares(1,n) = [Cap(1,n)/X(1,n)];

end


value = X.*repmat(shares,L,1);

days=length(value);

portfolio = sum(value,2);



%The allocation results


%Fit to portfolio to get interest rate

fit_portfolio=polyfit(1:length(portfolio),transpose(portfolio(:,:)),1);

%Calculate the best fit to the simulation interest rate
IR=(5/7)*365*fit_portfolio(1,1)/portfolio(1,1); % 5/7 is to adjust for Business days 
Final_Value=portfolio(size(portfolio,1));
Profit=Final_Value-Capital;

res=num2cell(zeros(2,size(symbols,2)));
res(1,:)=symbols;
res(2,:)=num2cell(Cap);
results=transpose(res);


%Displaying the Final Value:

set(handles.final,'string',Final_Value);

%% Let the plotting begin


% axes1
colordef black
%Figure 1:
plot(handles.axes1,Xnorm,'--');
legend(handles.axes1,symbols);




%%2 To plot the fit to the portfolio
fixed_portfolio=zeros(size(portfolio,1),1);
fixed_portfolio(1)=portfolio(1);

ii=1;
while ii<size(portfolio,1);
    ii=ii+1;
fixed_portfolio(ii)=fixed_portfolio(ii-1)*(IR/(365*(5/7)))+fixed_portfolio(ii-1);
end




index = [1:length(portfolio)]';



%% Manual




 
 
 
%% normalize prices
L = length(X);

Xnorm = X./repmat(X(1,:),L,1);



%%Plugging in the Portfolio Optimization results here.


for n=1:manual_quantity
 
    manual_shares(1,n) = [manual_Cap(n)/X(1,n)];

end


manual_value = X.*repmat(manual_shares,L,1);

days=length(value);

manual_portfolio = sum(manual_value,2);



%The allocation results


%Fit to portfolio to get interest rate

fit_manual_portfolio=polyfit(1:length(manual_portfolio),transpose(manual_portfolio(:,:)),1);

%Calculate the best fit to the simulation interest rate
manual_IR=(5/7)*365*fit_manual_portfolio(1,1)/manual_portfolio(1,1); % 5/7 is to adjust for Business days 
Final_Manual_Value=manual_portfolio(size(manual_portfolio,1));
Manual_Profit=Final_Manual_Value-Capital;

manual_res=num2cell(zeros(2,size(symbols,2)));
manual_res(1,:)=symbols;
manual_res(2,:)=num2cell(manual_Cap);
manual_results=transpose(manual_res);


%Displaying the Final Value:

set(handles.manual_final,'string',Final_Manual_Value);



%%2 To plot the fit to the portfolio
fixed_manual_portfolio=zeros(size(manual_portfolio,1),1);
fixed_manual_portfolio(1)=manual_portfolio(1);


ii=1;
while ii<size(manual_portfolio,1);
    ii=ii+1;
fixed_manual_portfolio(ii)=fixed_manual_portfolio(ii-1)*(manual_IR/(365*(5/7)))+fixed_manual_portfolio(ii-1);
end


%Setting Up portfolio_risk Matrix (For Manual Allocation)

%for i=1:manual_quantity;
%portfolio_risk(i)=(1-1/m(i));
%end
%risk=max(portfolio_risk)*100;

%set(handles.portfolio_risk,'string',round(risk*10)/10);




colordef black
%Figure 2: 
plot(handles.axes2,index,(portfolio),'w-',index,(manual_portfolio),'c-'),grid;
legend(handles.axes2,'Simulation ',['Sim. Annual Gain : ',num2str(round(IR*1000)/10) ,'%'],'Market Value ',['Manual Annual Gain : ',num2str(round(manual_IR*1000)/10) ,'%']);


colordef black
%Figure 3: 
plot(handles.axes3,index,(manual_portfolio),'c-'),grid;
legend(handles.axes3,'Market Value',['Manual Annual Gain : ',num2str(round(manual_IR*1000)/10) ,'%']);


% --- Executes on button press in restart.
function restart_Callback(hObject, eventdata, handles)
% hObject    handle to restart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m1_Callback(hObject, eventdata, handles)
% hObject    handle to m1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m1 as text
%        str2double(get(hObject,'String')) returns contents of m1 as a double


% --- Executes during object creation, after setting all properties.
function m1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m2_Callback(hObject, eventdata, handles)
% hObject    handle to m2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m2 as text
%        str2double(get(hObject,'String')) returns contents of m2 as a double


% --- Executes during object creation, after setting all properties.
function m2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m3_Callback(hObject, eventdata, handles)
% hObject    handle to m3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m3 as text
%        str2double(get(hObject,'String')) returns contents of m3 as a double


% --- Executes during object creation, after setting all properties.
function m3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m4_Callback(hObject, eventdata, handles)
% hObject    handle to m4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m4 as text
%        str2double(get(hObject,'String')) returns contents of m4 as a double


% --- Executes during object creation, after setting all properties.
function m4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m5_Callback(hObject, eventdata, handles)
% hObject    handle to m5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m5 as text
%        str2double(get(hObject,'String')) returns contents of m5 as a double


% --- Executes during object creation, after setting all properties.
function m5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m6_Callback(hObject, eventdata, handles)
% hObject    handle to m6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m6 as text
%        str2double(get(hObject,'String')) returns contents of m6 as a double


% --- Executes during object creation, after setting all properties.
function m6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m7_Callback(hObject, eventdata, handles)
% hObject    handle to m7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m7 as text
%        str2double(get(hObject,'String')) returns contents of m7 as a double


% --- Executes during object creation, after setting all properties.
function m7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ma1_Callback(hObject, eventdata, handles)
% hObject    handle to ma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ma1 as text
%        str2double(get(hObject,'String')) returns contents of ma1 as a double


% --- Executes during object creation, after setting all properties.
function ma1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ma2_Callback(hObject, eventdata, handles)
% hObject    handle to ma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ma2 as text
%        str2double(get(hObject,'String')) returns contents of ma2 as a double


% --- Executes during object creation, after setting all properties.
function ma2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ma3_Callback(hObject, eventdata, handles)
% hObject    handle to ma3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ma3 as text
%        str2double(get(hObject,'String')) returns contents of ma3 as a double


% --- Executes during object creation, after setting all properties.
function ma3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ma3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ma4_Callback(hObject, eventdata, handles)
% hObject    handle to ma4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ma4 as text
%        str2double(get(hObject,'String')) returns contents of ma4 as a double


% --- Executes during object creation, after setting all properties.
function ma4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ma4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ma5_Callback(hObject, eventdata, handles)
% hObject    handle to ma5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ma5 as text
%        str2double(get(hObject,'String')) returns contents of ma5 as a double


% --- Executes during object creation, after setting all properties.
function ma5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ma5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ma6_Callback(hObject, eventdata, handles)
% hObject    handle to ma6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ma6 as text
%        str2double(get(hObject,'String')) returns contents of ma6 as a double


% --- Executes during object creation, after setting all properties.
function ma6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ma6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ma7_Callback(hObject, eventdata, handles)
% hObject    handle to ma7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ma7 as text
%        str2double(get(hObject,'String')) returns contents of ma7 as a double


% --- Executes during object creation, after setting all properties.
function ma7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ma7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function message_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to message_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


%% Restart Button 

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.time_from,'string','22-Feb-2009')
set(handles.time_to,'string','19-Oct-2014')


% Capital 

set(handles.ma1,'string',25000);
set(handles.ma2,'string',25000);
set(handles.ma3,'string',25000);
set(handles.ma4,'string',25000);
set(handles.ma5,'string',0);
set(handles.ma6,'string',0);
set(handles.ma7,'string',0);

% indices

set(handles.m1,'string','YHOO');
set(handles.m2,'string','BMO');
set(handles.m3,'string','AAPL');
set(handles.m4,'string','MSFT');
set(handles.m5,'string','');
set(handles.m6,'string','');
set(handles.m7,'string','');





time_from=get(handles.time_from,'string');
time_to=get(handles.time_to,'string');




% Capital 
ma1=str2num(get(handles.ma1,'string'));
ma2=str2num(get(handles.ma2,'string'));
ma3=str2num(get(handles.ma3,'string'));
ma4=str2num(get(handles.ma4,'string'));
ma5=str2num(get(handles.ma5,'string'));
ma6=str2num(get(handles.ma6,'string'));
ma7=str2num(get(handles.ma7,'string'));



Capital=ma1+ma2+ma3+ma4+ma5+ma6+ma7;

%Display the initial Capital 


set(handles.initial_capital,'string',Capital);

% indices

m1=get(handles.m1,'string');
m2=get(handles.m2,'string');
m3=get(handles.m3,'string');
m4=get(handles.m4,'string');
m5=get(handles.m5,'string');
m6=get(handles.m6,'string');
m7=get(handles.m7,'string');

set(handles.s1,'string',m1);
set(handles.s2,'string',m2);
set(handles.s3,'string',m3);
set(handles.s4,'string',m4);
set(handles.s5,'string',m5);
set(handles.s6,'string',m6);
set(handles.s7,'string',m7);



temp_symbols = {m1,m2,m3,m4,m5,m6,m7};



j=1;
for i=1:length(temp_symbols);
    if char(temp_symbols(1,i))~'';
       symbols(j)=temp_symbols(i);
       j=j+1;
    end
end
        



[y, dates] = get_yahoo_data(symbols,time_from,time_to);


%2- How many index? 
quantity=size(symbols,2);

X=y(:,:);









%% Tracking process 

%Capital Matrix: 
Cap=zeros(1,quantity);  



n=1;
while n<=quantity 
    
   %fitting a line to the data for each index.  
   fit=polyfit(1:length(X(:,n)),transpose(X(:,n)),1);
   
   %selecting out the slope from the fit data:
   m(1,n)=fit(1);
    
 
          n=n+1;
          
 end 

 %% Allocation process:
   %Normalization: sum of alpha*(1/m(1,i))=1
   
     su=0;
for w=1:quantity;
   su=su+1/m(1,w);
end
alpha=1/su;
   
   %Final allocation:
for t=1:quantity; 
    Cap(1,t)=Capital*(1/m(1,t))*alpha;
end



%% normalize prices
L = length(X);

Xnorm = X./repmat(X(1,:),L,1);



%%Plugging in the Portfolio Optimization results here.


for n=1:quantity
 
    shares(1,n) = [Cap(1,n)/X(1,n)];

end


value = X.*repmat(shares,L,1);

days=length(value);

portfolio = sum(value,2);



%The allocation results


%Fit to portfolio to get interest rate

fit_portfolio=polyfit(1:length(portfolio),transpose(portfolio(:,:)),1);

%Calculate the best fit to the simulation interest rate
IR=(5/7)*365*fit_portfolio(1,1)/portfolio(1,1); % 5/7 is to adjust for Business days 
Final_Value=portfolio(size(portfolio,1));
Profit=Final_Value-Capital;

res=num2cell(zeros(2,size(symbols,2)));
res(1,:)=symbols;
res(2,:)=num2cell(Cap);
results=transpose(res);


%Displaying the Final Value:

set(handles.final,'string',Final_Value);


%% Let the plotting begin


% axes1
colordef black
%Figure 1:
plot(handles.axes1,Xnorm,'--');
legend(handles.axes1,symbols);
set(gcf,'Color','k')
set(gca,'color','k')





savings=zeros(size(portfolio,1),1);
savings(1)=portfolio(1);

i=1;
while i<size(portfolio,1);
    i=i+1;
savings(i)=savings(i-1)*(0.012/(365*(5/7)))+savings(i-1);
end


%%2 To plot the fit to the portfolio
fixed_portfolio=zeros(size(portfolio,1),1);
fixed_portfolio(1)=portfolio(1);

i=1;
while i<size(portfolio,1);
    i=i+1;
fixed_portfolio(i)=fixed_portfolio(i-1)*(IR/(365*(5/7)))+fixed_portfolio(i-1);
end


%%%%%%
%portfolio_savings=zeros(size(savings,1),3);
%portfolio_savings(:,1)=portfolio(:,1);                       Garbage
%portfolio_savings(:,2)=savings(:,1);
%portfolio_savings(:,3)=fixed_portfolio(:,1);
%%%%%

index = [1:length(portfolio)]';



%% Manual


%2- How many index? 
manual_quantity=size(symbols,2);

X=y(:,:);

%Capital Matrix: 
manual_Cap=zeros(1,manual_quantity);  

manual_Cap(1,1)=ma1;
manual_Cap(1,2)=ma2;
manual_Cap(1,3)=ma3;
manual_Cap(1,4)=ma4;





%Displaying the suggested allocation 

display_results=zeros(length(Cap),1);

j=1;
for i=1:length(temp_symbols);
    if char(temp_symbols(1,i))~'';
       display_results(j)=Cap(i);
       
       j=j+1;
       else
         display_results(i)=0;
        
    end
end



set(handles.sa1,'string',display_results(1));
set(handles.sa2,'string',display_results(2));
set(handles.sa3,'string',display_results(3));
set(handles.sa4,'string',display_results(4));
set(handles.sa5,'string',display_results(5));
set(handles.sa6,'string',display_results(6));
set(handles.sa7,'string',display_results(7));



 %% Manual Allocation:
 
 
 
%% normalize prices
L = length(X);

Xnorm = X./repmat(X(1,:),L,1);



%%Plugging in the Portfolio Optimization results here.


for n=1:quantity
 
    manual_shares(1,n) = [manual_Cap(1,n)/X(1,n)];

end


manual_value = X.*repmat(manual_shares,L,1);

days=length(value);

manual_portfolio = sum(manual_value,2);



%The allocation results


%Fit to portfolio to get interest rate

fit_manual_portfolio=polyfit(1:length(manual_portfolio),transpose(manual_portfolio(:,:)),1);

%Calculate the best fit to the simulation interest rate
manual_IR=(5/7)*365*fit_manual_portfolio(1,1)/manual_portfolio(1,1); % 5/7 is to adjust for Business days 
Final_Manual_Value=manual_portfolio(size(manual_portfolio,1));
Manual_Profit=Final_Manual_Value-Capital;

manual_res=num2cell(zeros(2,size(symbols,2)));
manual_res(1,:)=symbols;
manual_res(2,:)=num2cell(manual_Cap);
manual_results=transpose(manual_res);


%Displaying the Final Value:

set(handles.manual_final,'string',Final_Manual_Value);




%%2 To plot the fit to the portfolio
fixed_manual_portfolio=zeros(size(manual_portfolio,1),1);
fixed_manual_portfolio(1)=manual_portfolio(1);


i=1;
while i<size(manual_portfolio,1);
    i=i+1;
fixed_manual_portfolio(i)=fixed_manual_portfolio(i-1)*(manual_IR/(365*(5/7)))+fixed_manual_portfolio(i-1);
end




colordef black
%Figure 2: 
plot(handles.axes2,index,(portfolio),'w-',index,(manual_portfolio),'c-'),grid;
legend(handles.axes2,'Simulation ',['Sim. Annual Gain : ',num2str(round(IR*1000)/10) ,'%'],'Market Value ',['Portfolio Annual Gain : ',num2str(round(manual_IR*1000)/10) ,'%']);


colordef black
%Figure 3: 
plot(handles.axes3,index,(manual_portfolio),'c-'),grid;
legend(handles.axes3,'Market Value',['Portfolio Annual Gain : ',num2str(round(manual_IR*1000)/10) ,'%']);




% Choose default command line output for portfolio_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.


% --- Executes during object creation, after setting all properties.


% --- Executes during object creation, after setting all properties.
