%% X_Trader Price Update Depth example
% This example populates a table with market depth information as the
% prices update.  Note that X_Trader is a 32-bit application and will only
% work with 32-bit Windows installations of MATLAB.
%
%  Copyright 2012 The MathWorks, Inc.

%% Start or connect to XTrader
x = xtrdr;

%% Create event notifier and enable depth updates
x.createNotifier;
x.InstrNotify(1).EnableDepthUpdates = 1;

%% Create an instrument
x.createInstrument('Exchange','TTSIM-G','Product','IPE e-Brent',...
    'ProdType','Future','Contract','Oct12','Alias','Demo6b_PriceUdateDepth');

%% Attach an instrument to a notifier
x.InstrNotify(1).AttachInstrument(x.Instrument(1));

%% Define events
x.InstrNotify(1).registerevent({'OnNotifyFound',@ttinstrumentfound})
x.InstrNotify(1).registerevent({'OnNotifyNotFound',@ttinstrumentnotfound})
x.InstrNotify(1).registerevent({'OnNotifyDepthData',@ttinstrumentdepthupdate})

%% Depth data will be displayed in figure window
figure('Numbertitle','off','Tag','TTPriceUpdateDepthFigure','Name',['Order Book - ' x.Instrument(1).Alias]);
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 360 315],'Resize','off')

% Create controls for last price data
bspc = 5;
bwid = 80;
bhgt = 20;
uicontrol('Style','text','String','Exchange','Position',[bspc 4*bspc+3*bhgt bwid bhgt]);
uicontrol('Style','text','String','Product','Position',[2*bspc+bwid 4*bspc+3*bhgt bwid bhgt]);
uicontrol('Style','text','String','Type','Position',[3*bspc+2*bwid 4*bspc+3*bhgt bwid bhgt]);
uicontrol('Style','text','String','Contract','Position',[4*bspc+3*bwid 4*bspc+3*bhgt bwid bhgt]);
ui.Exchange = uicontrol('Style','text','Tag','','Position',[bspc 3*bspc+2*bhgt bwid bhgt]);
ui.Product = uicontrol('Style','text','Tag','','Position',[2*bspc+bwid 3*bspc+2*bhgt bwid bhgt]);
ui.Type = uicontrol('Style','text','Tag','','Position',[3*bspc+2*bwid 3*bspc+2*bhgt bwid bhgt]);
ui.Contract = uicontrol('Style','text','Tag','','Position',[4*bspc+3*bwid 3*bspc+2*bhgt bwid bhgt]);
uicontrol('Style','text','String','Last Price','Position',[bspc 2*bspc+bhgt bwid bhgt]);
uicontrol('Style','text','String','Last Qty','Position',[2*bspc+bwid 2*bspc+bhgt bwid bhgt]);
uicontrol('Style','text','String','Change','Position',[3*bspc+2*bwid 2*bspc+bhgt bwid bhgt]);
ui.Last = uicontrol('Style','text','Tag','','Position',[bspc bspc bwid bhgt]);
ui.Quantity = uicontrol('Style','text','Tag','','Position',[2*bspc+bwid bspc bwid bhgt]);
ui.Change = uicontrol('Style','text','Tag','','Position',[3*bspc+2*bwid bspc bwid bhgt]);

%Create table with order information
data = {' '};
data = data(ones(10,4));
uibook = uitable('Data', data, 'ColumnName', ...
                {'Bid','Bid Size','Ask','Ask Size'}, ...
                 'Position', [5 105 350 205]);

%Store ui data
setappdata(0,'TTOrderBookHandle',uibook)
setappdata(0,'TTOrderBookUIData',ui)

%% Listen for event data with depth updates enabled
x.Instrument(1).Open(1);

%% Pause 10 seconds, then close
pause(10)
disp('Shutting down communications to X_Trader.')
close(x)