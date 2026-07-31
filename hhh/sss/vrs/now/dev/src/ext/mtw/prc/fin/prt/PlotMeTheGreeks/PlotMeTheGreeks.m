function varargout = PlotMeTheGreeks(varargin)
% PLOTMETHEGREEKS M-file for PlotMeTheGreeks.fig
%       A useful tool built to help the user gain an intuitive 
%        feel for option pricing and the greeks. Allows the user
%        to create a portfolio of options (and thus straddles, strangles,
%        butterflies and anything else you fancy can be easily created).
%         One can then plot the greeks in 3d to see how they vary with
%         time, volatility, interest rates etc. It also allows you to
%         perturb a 4th dimension thus also allowing you to create an
%         animation.
%
%       To use, run PLOTMETHEGREEKS from the command line, create your
%       portfolio, set your axes, choose the greek you would like to plot
%       and then play with the z-variables to see how the greeks change.
%
%   version: v1.0
%   author: Yazann Romahi [yazann@romahi.com]

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PlotMeTheGreeks_OpeningFcn, ...
                   'gui_OutputFcn',  @PlotMeTheGreeks_OutputFcn, ...
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


% --- Executes just before PlotMeTheGreeks is made visible.
function PlotMeTheGreeks_OpeningFcn(hObject, eventdata, handles, varargin)
    handles.output = hObject;

    myfig=figure; % create figure to plot graphics to
    set(myfig, 'Tag', 'MyFigure');

    h=findobj('Tag', 'startdateviewer');
    startdate=datestr(today-365);
    set(h,'String',startdate);
    
    h=findobj('Tag', 'enddateviewer');
    enddate=datestr(today);
    set(h,'String',enddate);

    h=findobj('Tag', 'timetext');
    set(h,'String',startdate);
    
    warning off all;
% Update handles structure
    guidata(hObject, handles);


function varargout = PlotMeTheGreeks_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function timeslider_Callback(hObject, eventdata, handles)

    h=findobj('Tag', 'enddateviewer');
    enddate=datenum(get(h,'String'));
    
    h=findobj('Tag', 'startdateviewer');
    startdate=datenum(get(h,'String'));

    yrs=(enddate-startdate)/360;
    blah=get(hObject,'Value');
    h=findobj('Tag', 'timetext');
    set(h, 'String', datestr((blah)*yrs*360+startdate));
    UpdateGraph();
    
    % --- Executes during object creation, after setting all properties.
function timeslider_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
    UpdateGraph(1);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
     SetObjVisible('timeslider',1);
     SetObjVisible('timetext',1);
     SetObjVisible('volslider',1);
     SetObjVisible('voltext',1);
     SetObjVisible('int1slider',1);
     SetObjVisible('int1text',1);
     SetObjVisible('int2slider',1);
     SetObjVisible('int2text',1);
     
     b=get(hObject,'Value');
     switch b
         case 1
            SetObjVisible('timeslider',0);
            SetObjVisible('timetext',0);
         case 2
             SetObjVisible('volslider',0);
             SetObjVisible('voltext',0);
         case 3
             SetObjVisible('int1slider',0);
             SetObjVisible('int1text',0);
         case 4
            SetObjVisible('int2slider',0);
            SetObjVisible('int2text',0);
     end
    UpdateGraph();


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function volslider_Callback(hObject, eventdata, handles)
    h=findobj('Tag', 'maxvol');
    maxvol=str2num(get(h,'String'));
    h=findobj('Tag', 'minvol');
    minvol=str2num(get(h,'String'));
    
    blah=get(hObject,'Value');
    h=findobj('Tag', 'voltext');
    set(h, 'String', num2str((blah*(maxvol-minvol)+minvol)));
    UpdateGraph();


% --- Executes during object creation, after setting all properties.
function volslider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function int1slider_Callback(hObject, eventdata, handles)
    h=findobj('Tag', 'maxint1');
    maxint1=str2num(get(h,'String'));
    h=findobj('Tag', 'minint1');
    minint1=str2num(get(h,'String'));

    blah=get(hObject,'Value');
    h=findobj('Tag', 'int1text');
    set(h, 'String', num2str((blah*(maxint1-minint1)+minint1)));
    UpdateGraph();

    

% --- Executes during object creation, after setting all properties.
function int1slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function int2slider_Callback(hObject, eventdata, handles)
    h=findobj('Tag', 'maxint2');
    maxint2=str2num(get(h,'String'));
    h=findobj('Tag', 'minint2');
    minint2=str2num(get(h,'String'));

    blah=get(hObject,'Value');
    h=findobj('Tag', 'int2text');
    set(h, 'String', num2str((blah*(maxint2-minint2)+minint2)));
    UpdateGraph();



% --- Executes during object creation, after setting all properties.
function int2slider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function UpdateGraph(toupdate)

    if nargin<1
        toupdate=0;
    end
    
    h=findobj('Tag', 'popupmenu1');
    contents=get(h,'String');
    yaxisLabel=contents{get(h,'Value')};
    
    h=findobj('Tag', 'popupmenu2');
    contents=get(h,'String');
    zaxisLabel=contents{get(h,'Value')};
   
    h=findobj('Tag', 'xmin');
    xmin=str2num(get(h,'String'));
    h=findobj('Tag', 'xmax');
    xmax=str2num(get(h,'String'));
    
    h=findobj('Tag', 'ymin');
    ymin=str2num(get(h,'String'));
    h=findobj('Tag', 'ymax');
    ymax=str2num(get(h,'String'));

    h=findobj('Tag', 'maxvol');
    maxvol=str2num(get(h,'String'))/100;
    h=findobj('Tag', 'minvol');
    minvol=str2num(get(h,'String'))/100;

    h=findobj('Tag', 'maxint1');
    maxint1=str2num(get(h,'String'))/100;
    h=findobj('Tag', 'minint1');
    minint1=str2num(get(h,'String'))/100;
    
    h=findobj('Tag', 'maxint2');
    maxint2=str2num(get(h,'String'))/100;
    h=findobj('Tag', 'minint2');
    minint2=str2num(get(h,'String'))/100;

    h=findobj('Tag', 'voltext');
    sigma=str2num(get(h,'String'))/100;
    
    h=findobj('Tag', 'timetext');
    todaydate=datenum(get(h,'String'));
    
    h=findobj('Tag','enddateviewer');
    enddate=datenum(get(h,'String'));
    
    h=findobj('Tag', 'startdateviewer');
    startdate=datenum(get(h,'String'));
    
    h=findobj('Tag', 'int1text');
    int1=str2num(get(h,'String'))/100;

    h=findobj('Tag', 'int2text');
    int2=str2num(get(h,'String'))/100;

    h=findobj('Tag', 'popupmenu1');
    axis1=get(h,'Value');
    
    h=findobj('Tag', 'popupmenu2');
    axis2=get(h,'Value');

    %First we create the meshgrid
    switch axis2
        case 1
            [S,todaydate]=meshgrid(xmin:0.01*abs(xmax):xmax,startdate:0.01*(enddate-startdate):enddate);
        case 2
            [S,sigma]=meshgrid(xmin:0.01*abs(xmax-xmin):xmax,minvol:0.01*abs(maxvol-minvol):maxvol);
        case 3
            [S,int1]=meshgrid(xmin:0.01*abs(xmax-xmin):xmax,minint1:0.01*abs(maxvol-minvol):maxint1);
        case 4
            [S,int2]=meshgrid(xmin:0.01*abs(xmax-xmin):xmax,minint2:0.01*abs(maxvol-minvol):maxint2);
    end
    [ss1 ss2]=size(S);
    greek=zeros(ss1,ss2); %fill with zeros in case portfolio is empty
    
    myfig=findobj('Tag', 'MyFigure');
    figure(myfig);
    h=findobj('Tag', 'portfolio');
    contents=get(h,'String');
    mycount=0;
    for counter=3:length(contents)
        if ~strcmp(contents{counter},'--')
            mycount=mycount+1;
            [type X Pos expiry]=ParseMy(contents{counter}); %Go through portfolio
            
            Tn=(expiry-todaydate)./360;
            Tn=Tn.*(Tn>0);
            
            switch axis1
                case 1
                    newgreek=Pos*GKprice(type, S, X, Tn, int1,int2,sigma);
                case 2
                    newgreek=Pos*bsDelta(type, S, X, Tn, int1,int2,sigma);
                case 3
                    newgreek=Pos*ReplaceNaN(bsGamma(type, S, X, Tn, int1,int2,sigma));
                case 4
                    newgreek=Pos*ReplaceNaN(bsTheta(type, S, X, Tn, int1,int2,sigma));
                case 5
                    newgreek=Pos*bsVega(type, S, X, Tn, int1,int2,sigma);
                case 6
                    newgreek=Pos*bsVarVega(type, S, X, Tn, int1,int2,sigma);
            end
            if mycount==1
                greek=newgreek;
            else
                greek=greek+newgreek;
            end
        end
    end
    if toupdate % if we have changed greek view, then change axes
        ymin=min(min(greek));
        if isnan(ymin)
            ymin=0
        end
        ymax=max(max(greek));
        if isnan(ymax)
            ymax=0
        end
         if (ymin==0 & ymax==0)
             ymin=-1
             ymax=1;
         end
        UpdateAxes(ymax,ymin);
    end
    
    switch axis2
        case 1
            h=surf(S,todaydate,greek);
            axis([xmin xmax startdate enddate ymin ymax -100 100]); 
            if (enddate-startdate)>10
                dateaxis('y',1);
            else
                dateaxis('y',0); % plots axes with hours if we are viewing less than 10 days
            end
        case 2
            h=surf(S, sigma*100, greek);
            axis([xmin xmax minvol*100 maxvol*100 ymin ymax -100 100]); 
        case 3
            h=surf(S,int1*100,greek);
            axis([xmin xmax minint1*100 maxint1*100 ymin ymax -100 100]);
        case 4
            h=surf(S,int2*100,greek);
            axis([xmin xmax minint2*100 maxint2*100 ymin ymax -100 100]);
    end
    xlabel('Underlying Price');
    ylabel(zaxisLabel);
    zlabel(yaxisLabel);
    caxis auto;
    colormap hsv



function maxvol_Callback(hObject, eventdata, handles)
    UpdateGraph()


% --- Executes during object creation, after setting all properties.
function maxvol_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minvol_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function minvol_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxint1_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function maxint1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxint2_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function maxint2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minint2_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function minint2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minint1_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function minint1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function xmin_Callback(hObject, eventdata, handles)
    h=findobj('Tag', 'xmax');
    xmin=str2num(get(hObject, 'String'));
    xmax=str2num(get(h, 'String'));
    
    if isempty(xmin)
        errordlg('Please enter a reasonable limit');
        set(hObject, 'String', num2str(0));
    elseif xmin<0
        errordlg('A security cannot have a negative price');
        set(hObject, 'String', num2str(0));
    elseif xmin>xmax
         errordlg('Minimum should be less than maximum on axis.');
        if xmax<0
            xmax=2*xmax;
        end
        set(hObject, 'String', num2str(round(0.8*xmax)));
    else
       
        UpdateGraph();
    end


% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmax_Callback(hObject, eventdata, handles)
    h=findobj('Tag', 'xmin');
    xmin=str2num(get(h, 'String'));
    xmax=str2num(get(hObject, 'String'));
    
    if isempty(xmax)
        errordlg('Please enter a reasonable limit');
        set(hObject, 'String', num2str(xmin+10));
    elseif xmax<=0
        errordlg('A security cannot have a negative price');
        set(hObject, 'String', num2str(xmin+10));
    elseif xmin>xmax
         errordlg('Minimum should be less than maximum on axis.');
        set(hObject, 'String', num2str(round(1.2*xmin)));
    else     
        UpdateGraph();
    end


% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymin_Callback(hObject, eventdata, handles)
    h=findobj('Tag', 'ymax');
    ymin=str2num(get(hObject, 'String'));
    ymax=str2num(get(h, 'String'));

    if isempty(ymin)
        errordlg('Please enter a reasonable limit');
        set(hObject, 'String', num2str(ymax-10));
    elseif ymin>ymax
         errordlg('Minimum should be less than maximum on axis.');
        set(hObject, 'String', num2str(ymax-10));
    else     
        UpdateGraph();
    end
     

% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymax_Callback(hObject, eventdata, handles)
    h=findobj('Tag', 'ymin');
    ymin=str2num(get(h, 'String'));
    ymax=str2num(get(hObject, 'String'));
    
    if isempty(ymax)
        errordlg('Please enter a reasonable limit');
        set(hObject, 'String', num2str(ymin+10));
    elseif ymin>ymax
         errordlg('Minimum should be less than maximum on axis.');
        set(hObject, 'String', num2str(ymin+10));
    else     
        UpdateGraph();
    end


% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in portfolio.
function portfolio_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function portfolio_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in type.
function type_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function type_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function X_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function X_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
UpdateGraph()


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in add2portfolio.
function add2portfolio_Callback(hObject, eventdata, handles)
    myerror='None';
    h=findobj('Tag', 'type');
    contents=get(h,'String');
    type=contents{get(h,'Value')};

    h=findobj('Tag', 'X');
    X=get(h,'String');
    if isempty(str2num(X))
        myerror='Need to specify strike price X.';
    end

    h=findobj('Tag', 'Tbutton');
    T=get(h,'String');
    if strcmp(T, 'Click to Set Expiry')
        myerror='Need to set expiry date for option';
    end
    
    h=findobj('Tag', 'pos');
    Pos=get(h,'String');
    if isempty(str2num(Pos))
        myerror='Need to specify position size. eg. -0.2 means short 20% notional';
    end
    if strcmp(myerror,'None')
        h=findobj('Tag', 'portfolio');
        contents=get(h,'String');
        newstring=[Pos '*' type '(' X ',' T ')'];
        done=0;
        for i=1:length(contents)
            if strcmp(contents{i}, '--') & done==0
                contents{i}=newstring;
                done=1;
            end
        end
        if done==0
            contents{length(contents)+1}=newstring;
        end
        set(h,'String', contents);
        UpdateGraph()
    else
        errordlg(myerror);
    end




function pos_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function pos_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)


    h=findobj('Tag', 'portfolio');
    contents=get(h,'String');
    pos=get(h,'Value');
    if pos>2
        contents{pos}='--';
    end
    set(h,'String', contents);
    UpdateGraph();
    
    
    
    
function [type X Pos expiry]= ParseMy(b)
    
    a1=regexp(b,'*');
    a2=regexp(b,'(');
    a3=regexp(b,',');
    a4=regexp(b,')');
    
    Pos=str2num(b(1:a1-1));
    type=b(a1+1:a1+1);
    X=str2num(b(a2+1:a3-1));
    expiry=datenum(b(a3+1:end-1));
    
    
function UpdateAxes(ymax,ymin)
      
    obj1=findobj('Tag', 'ymin');
    obj2=findobj('Tag', 'ymax');
    set(obj1,'String',num2str(ymin));
    set(obj2,'String',num2str(ymax));
 
    
function aa=ReplaceNaN(aa)
    [rows cols]=size(aa);
    for x=1:rows
        for y=1:cols
            if isnan(aa(x,y))
                aa(x,y)=0;
            end
        end
    end    


function enddate_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function enddate_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enddatebutton.
function enddatebutton_Callback(hObject, eventdata, handles)
    enddate=uigetdate();
    obj1=findobj('Tag', 'enddateviewer');    
    set(obj1,'String',datestr(enddate));


% --- Executes on button press in Tbutton.
function Tbutton_Callback(hObject, eventdata, handles)
    expdate=uigetdate();
    if ~isempty(expdate)
        set(hObject,'String',datestr(expdate));
    end

% --- Executes on button press in startdatebutton.
function startdatebutton_Callback(hObject, eventdata, handles)
    startdate=uigetdate();
    startdate=datenum(startdate)
    obj1=findobj('Tag', 'enddateviewer');    
    enddate=datenum(get(obj1,'String'));

    if startdate>=enddate
        errordlg('Start Date must be *before* end date');
        startdate=enddate-30;
    end

    obj1=findobj('Tag', 'startdateviewer');
    set(obj1,'String',datestr(startdate));

function SetObjVisible(name,visibility)
     if visibility==1
         v='on';
     else
         v='off';
     end
     obj1=findobj('Tag', name);
     set(obj1, 'Visible', v);
     