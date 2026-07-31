%harmonograph
% GUI front end for digital Harmonograph. Influenced by "Harmonograph: A
% Visual Guide to the Mathematics of Music" by Anthony Ashton.
%
% LAST UPDATED by Andy French 18th March 2011

function varargout = harmonograph(varargin)

%% Initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @harmonograph_OpeningFcn, ...
    'gui_OutputFcn',  @harmonograph_OutputFcn, ...
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

%%

%% Harmonograph opening function. This executes just before harmonograph is made visible.
function harmonograph_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for harmonograph
handles.output = hObject;

%Add 'functions' directory to MATLAB path
addpath('functions','-begin');

%Center figure
set( handles.FIGUREhmg, 'position', figcenter( 'FIGUREhmg' ) );

%Turn off warnings (e.g. 'divide by zero')
warning off

%Load Harmonograph logo
axes( handles.AXESlogo );
image( imread('Functions\Harmonograph_logo.png' ));
axis tight
axis equal
axis off

% Load previous GUI settings, or default
if exist('last_hmg_settings.mat','file')
    load('last_hmg_settings.mat');
else
    HMG = hmg_default_settings;
end

%Store Harmonograph settings in handles array, to enable GUI callback
%functions to see this data
handles.HMG = HMG;

%Update GUI
handles = update_gui_from_HMG(handles);

% Update handles structure
guidata(hObject, handles);

% Update harmonograph
hmg_update

%%

%% Harmonograph output function. Outputs from this function are returned to the command line.
function varargout = harmonograph_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%

%% Amplitude ratio A slider
function SLIDERA_Callback(hObject, eventdata, handles)

%Compute value of slider
v = get(handles.SLIDERA,'value');

%Determine vale of A and update associated edit box
handles.HMG.A = handles.HMG.Alimits(1) + v * ( handles.HMG.Alimits(2) - handles.HMG.Alimits(1) );
set(handles.EDITA,'string',num2str(handles.HMG.A));

%Update GUI
hmg_update

%%

%% Frequency ratio F slider
function SLIDERF_Callback(hObject, eventdata, handles)

%Compute value of slider
v = get(handles.SLIDERF,'value');

%Determine vale of F and update associated edit box
handles.HMG.F = handles.HMG.Flimits(1) + v * ( handles.HMG.Flimits(2) - handles.HMG.Flimits(1) );
set(handles.EDITF,'string',num2str(handles.HMG.F));

%Update GUI
hmg_update

%%

%% Damping percentage per oscillation slider
function SLIDERD_Callback(hObject, eventdata, handles)

%Compute value of slider
v = get(handles.SLIDERD,'value');

%Determine vale of D and update associated edit box
handles.HMG.D = handles.HMG.Dlimits(1) + v * ( handles.HMG.Dlimits(2) - handles.HMG.Dlimits(1) );
set(handles.EDITD,'string',num2str(handles.HMG.D));

%Update GUI
hmg_update

%%

%% Phase between pairs between of oscillations slider
function SLIDERphi_Callback(hObject, eventdata, handles)

%Compute value of slider
v = get(handles.SLIDERphi,'value');

%Determine vale of phi and update associated edit box
handles.HMG.phi = handles.HMG.philimits(1) + v * ( handles.HMG.philimits(2) - handles.HMG.philimits(1) );
set(handles.EDITphi,'string',num2str(handles.HMG.phi));

%Update GUI
hmg_update

%%

%% Number of Harmonograph loops edit box
function EDITN_Callback(hObject, eventdata, handles)
hmg_update

%%

%% Number of Harmonograph points per loop edit box
function EDITM_Callback(hObject, eventdata, handles)
hmg_update

%%

%% Frequency ratio F edit box
function EDITF_Callback(hObject, eventdata, handles)

%Get numerical value of F
handles.HMG.F = str2num( get(handles.EDITF,'string') );

%Check limits and clip if necessary
if handles.HMG.F > handles.HMG.Flimits(2)
    handles.HMG.F = handles.HMG.Flimits(2);
elseif handles.HMG.F < handles.HMG.Flimits(1)
    handles.HMG.F = handles.HMG.Flimits(1);
end

%Update EDIT box
set(handles.EDITF,'string',num2str( handles.HMG.F ) );

%Update slider
v = ( handles.HMG.F - handles.HMG.Flimits(1) ) ...
    / ( handles.HMG.Flimits(2) - handles.HMG.Flimits(1) );
set(handles.SLIDERF,'value',v);

%Update Harmonograph
hmg_update

%%


%% Amplitude ratio A edit box
function EDITA_Callback(hObject, eventdata, handles)

%Get numerical value of A
handles.HMG.A = str2num( get(handles.EDITA,'string') );

%Check limits and clip if necessary
if handles.HMG.A > handles.HMG.Alimits(2)
    handles.HMG.A = handles.HMG.Alimits(2);
elseif handles.HMG.A < handles.HMG.Alimits(1)
    handles.HMG.A = handles.HMG.Alimits(1);
end

%Update EDIT box
set(handles.EDITA,'string',num2str( handles.HMG.A ) );

%Update slider
v = ( handles.HMG.A - handles.HMG.Alimits(1) ) ...
    / ( handles.HMG.Alimits(2) - handles.HMG.Alimits(1) );
set(handles.SLIDERA,'value',v);

%Update Harmonograph
hmg_update

%%

%% Phase between pairs between of oscillations
function EDITphi_Callback(hObject, eventdata, handles)

%Get numerical value of phi
handles.HMG.phi = str2num( get(handles.EDITphi,'string') );

%Check limits and clip if necessary
if handles.HMG.phi > handles.HMG.philimits(2)
    handles.HMG.phi = handles.HMG.philimits(2);
elseif handles.HMG.phi < handles.HMG.philimits(1)
    handles.HMG.phi = handles.HMG.philimits(1);
end

%Update EDIT box
set(handles.EDITphi,'string',num2str( handles.HMG.phi ) );

%Update slider
v = ( handles.HMG.phi - handles.HMG.philimits(1) ) ...
    / ( handles.HMG.philimits(2) - handles.HMG.philimits(1) );
set(handles.SLIDERphi,'value',v);

%Update Harmonograph
hmg_update

%%

%% Damping percentage per oscillation slider
function EDITD_Callback(hObject, eventdata, handles)

%Get numerical value of D
handles.HMG.D = str2num( get(handles.EDITD,'string') );

%Check limits and clip if necessary
if handles.HMG.D > handles.HMG.Dlimits(2)
    handles.HMG.D = handles.HMG.Dlimits(2);
elseif handles.HMG.D < handles.HMG.Dlimits(1)
    handles.HMG.D = handles.HMG.Dlimits(1);
end

%Update EDIT box
set(handles.EDITD,'string',num2str( handles.HMG.D ) );

%Update slider
v = ( handles.HMG.D - handles.HMG.Dlimits(1) ) ...
    / ( handles.HMG.Dlimits(2) - handles.HMG.Dlimits(1) );
set(handles.SLIDERD,'value',v);

%Update Harmonograph
hmg_update

%%

%% Harmonograph type popupmenu
function POPUPMENUhmgtype_Callback(hObject, eventdata, handles)
hmg_update

%%

%% Save .PNG file of current harmonograph
function PUSHsavepng_Callback(hObject, eventdata, handles)

%Create new figure containing a copy of the Harmonograph axes. Save a .png
%file bitmap from this figure into \plots and then close the figure.
[new_fig,new_ax] = plot_in_new_window(handles.FIGUREhmg,handles.AXEShmg,[],...
    [0.2139 0.0444 0.5111 0.8722],...
    handles.HMG.filename,2);

%%

%% Load default settings pushbutton
function PUSHdefault_Callback(hObject, eventdata, handles)

%Get Harmonograph default settings
HMG = hmg_default_settings;

%Store Harmonograph settings in handles array, to enable GUI callback
%functions to see this data
handles = guidata(hObject);
handles.HMG = HMG;

%Update GUI
handles = update_gui_from_HMG(handles);
guidata(hObject,handles);
hmg_update;

%%

%% Load settings pushbutton
function PUSHloadsettings_Callback(hObject, eventdata, handles)

%Return path to valid .mat file obtained via Explorer navigation by user
%which contains Harmonogrph setup information.
[filename, pathname, filterindex] = uigetfile('*.mat', 'Choose a .mat file containing harmonograph settings');

%Load .mat file and update handles array of GUI with information contained
%within the .mat file. If this doesn't work flag up an error dialogue box
old_HMG = handles.HMG;
try
    load( [pathname, '\', filename] );
    
    %Store Harmonograph settings in handles array, to enable GUI callback
    %functions to see this data
    handles = guidata(hObject);
    handles.HMG = HMG;
    
    %Update GUI
    handles = update_gui_from_HMG(handles);
    guidata(hObject,handles);
    hmg_update;
catch
    errordlg('.mat file selected does not contain the correct inputs for harmonograph','harmonograph error!')
    %Update GUI with original settings
    handles.HMG = old_HMG;
    handles = update_gui_from_HMG(handles);
    guidata(hObject,handles);
    hmg_update;
    return
end

%%

%% Save settings pushbutton
function PUSHsavesettings_Callback(hObject, eventdata, handles)

%Return path to valid .mat file obtained via Explorer navigation by user
%which will contains harmonograph setup information.
[filename, pathname, filterindex] = uiputfile('*.mat', 'Save harmonograph GUI settings in a .mat file');

%Save .mat file containing GUI settings
if ~isequal(filename,0) && ~isequal(pathname,0)
    handles = guidata(hObject);
    HMG = handles.HMG;
    save( [pathname,'\',filename], 'HMG' );
end

%%

%% Play sounds pushbutton. Constructs a waveform based upon the Harmonograph
%time signal and plays this back via the computer's sound system.
function PUSHsounds_Callback(hObject, eventdata, handles)

%Load middle C sample into vector s. Fs is sample frequency in Hz.
middle_C_Hz = 261.625565;
[s,Fs,Nbits] = wavread('functions\middle_C.wav');
dim = size(s);

%Construct time vector /s
t = linspace(0,( dim(1)-1 )/Fs, dim(1) );

%Get GUI data and combine s with a pitch shifted version
freq_change_Hz = handles.HMG.F*middle_C_Hz - middle_C_Hz;
handles = guidata(hObject);
pitch_shift_modulator = exp( -2*pi*i*freq_change_Hz*t ).';
s_mod = s.*pitch_shift_modulator ;
s = real( s + s_mod );

%Play (normalized) sound
soundsc( s, Fs );

%%

%% Harmonograph update function. This will change the 'handles' array
function hmg_update

%Get GUI data
handles = guidata(gcf);

%Get data from GUI
handles = get_data_from_gui(handles);

%Construct Harmonograph
if strcmp( handles.HMG.type,'Lateral' )
    %Lateral Harmonograph
    [x,y,t] = lat_hmg( handles.HMG.N, handles.HMG.M, handles.HMG.f_Hz,...
        handles.HMG.F, handles.HMG.A, handles.HMG.D, handles.HMG.phi );
elseif strcmp( handles.HMG.type,'Rotary freq-damp' )
    %Rotary Harmonograph with frequency related damping
    [x,y,t] = rot_hmg_fdamp( handles.HMG.N,handles.HMG.M, handles.HMG.f_Hz,...
        handles.HMG.F, handles.HMG.A, handles.HMG.D, handles.HMG.phi,0 );
elseif strcmp( handles.HMG.type,'Contra-rotary freq-damp' )
    %Contra-rotary Harmonograph with frequency related damping
    [x,y,t] = rot_hmg_fdamp( handles.HMG.N,handles.HMG.M, handles.HMG.f_Hz,...
        handles.HMG.F, handles.HMG.A, handles.HMG.D, handles.HMG.phi,1 );
elseif strcmp( handles.HMG.type,'Lateral freq-damp' )
    %Lateral Harmonograph with frequency related damping
    [x,y,t] = lat_hmg_fdamp( handles.HMG.N,handles.HMG.M, handles.HMG.f_Hz,...
        handles.HMG.F, handles.HMG.A, handles.HMG.D, handles.HMG.phi );
elseif strcmp( handles.HMG.type,'Contra-rotary' )
    %Contra-rotary Harmonograph
    [x,y,t] = rot_hmg( handles.HMG.N,handles.HMG.M, handles.HMG.f_Hz,...
        handles.HMG.F, handles.HMG.A, handles.HMG.D, handles.HMG.phi,1 );
else
    %Rotary Harmonograph
    [x,y,t] = rot_hmg( handles.HMG.N,handles.HMG.M, handles.HMG.f_Hz,...
        handles.HMG.F, handles.HMG.A, handles.HMG.D, handles.HMG.phi,0 );
end

%Store Harmonograph in handles structure
handles.HMG.x = x;
handles.HMG.y = y;
handles.HMG.t = t;

%Construct title string
title_string = ...
    ['N=',num2str(handles.HMG.N),', A=',num2str(handles.HMG.A),', F=',num2str(handles.HMG.F),...
    ', phi=',num2str(handles.HMG.phi*180/pi),'^o, D=',num2str(handles.HMG.D)] ;

%Plot harmonograph
axes(handles.AXEShmg);
cla
plot(x,y,'r');
axis off
axis equal;
ylimits = get(gca,'ylim');
%set( gca, 'ylim', [ylimits(1),ylimits(2) + 0.1*( ylimits(2) - ylimits(1) ) ] );
tit = title({handles.HMG.type,title_string});
tit_xyz = get(tit,'position');
%set(tit,'position',[tit_xyz(1),tit_xyz(2) - + 0.1*( ylimits(2) - ylimits(1) ),tit_xyz(3)] )
drawnow

%Determine filename
handles.HMG.filename = [handles.HMG.type,' harmonograph ',...
    strrep( strrep(title_string,',',''),'^o',''),'.png'];

%Update guidata
guidata(gcf,handles);

%%

%% Close function
function hmg_close(hObject, eventdata, handles)

%Saves settings (in structure handles.HMG) to a .mat file and closes GUI
HMG = handles.HMG;
save last_hmg_settings HMG
closereq;

%Remove 'functions' directory from MATLAB path
rmpath('functions')

%End of code






