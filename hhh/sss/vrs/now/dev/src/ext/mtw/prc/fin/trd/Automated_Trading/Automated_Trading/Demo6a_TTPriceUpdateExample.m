%% X_Trader Price Update example
% This example show how to set up a listener and callback for a change in
% price.  Note that X_Trader is a 32-bit application and will only
% work with 32-bit Windows installations of MATLAB.
%
%  Copyright 2012 The MathWorks, Inc.
%% Start or connect to XTrader
x = xtrdr

%% Available methods
methods(x)

%% Available properties
properties(x)

%% Create event notifier
x.createNotifier

%% Create an instruments
x.createInstrument('Exchange','TTSIM-G','Product','IPE e-Brent',...
    'ProdType','Future','Contract','Oct12','Alias','Demo6a_PriceUdate')

%% Attach instruments to a notifier
x.InstrNotify(1).AttachInstrument(x.Instrument(1))

%% Define events
x.InstrNotify(1).registerevent({'OnNotifyFound',@(varargin)ttinstrumentfound(varargin{:})})
x.InstrNotify(1).registerevent({'OnNotifyNotFound',@(varargin)ttinstrumentnotfound(varargin{:})})
x.InstrNotify(1).registerevent({'OnNotifyUpdate',@(varargin)ttinstrumentupdate(varargin{:},x)})

%% Set the update filter to monitor only desired fields
x.InstrNotify(1).UpdateFilter = 'Last$,LastQty$,~LastQty$,Change$';

%% Listen for event data
x.Instrument(1).Open(0)

%% Display prices for 10 seconds, then shut down
pause(10)
disp('Shutting down communications to X_Trader.')
close(x)
