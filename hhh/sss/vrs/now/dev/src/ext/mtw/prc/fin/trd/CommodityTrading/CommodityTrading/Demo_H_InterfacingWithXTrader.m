%% Commodities Trading with MATLAB - Interfacing with a trading platform
% Once analysts have completed designing and testing their algorithm, it
% can be convenient to test it out in a real world setting by connecting to
% a trading platform. 
%
% In this script, we use Trading Toolbox to connect to the Trading
% Technologies' X_TRADER platform and listen to price updates for a
% particular instrument. We demonstrate that event-driven programming
% models can lend themselves well towards integrating with MATLAB code.

% Copyright 2013 The MathWorks, Inc.

%% Create X_TRADER connection
% First, we set up a connection with X_TRADER and examine the various
% methods and properties available to us with the object.
clc;clear
conn = xtrdr
methods(conn)
properties(conn)

%% Create event notifier
% In this section, we create an event notifier; we will attach specific
% instrument and event types in the next section.
conn.createNotifier

%% Create an instrument and listen to its events
% In this section, we specify the instrument we would like to receive
% updates on - the September 2013 WTI Crude Oil contracts. We also specify
% the events we would like to be notifed on (instrument being found,
% instrument not being found, or instrument data being updated), and
% specify callback functions as event handlers for each of these events.
% Next, we specify that we only want to be notified if particular fields
% get updated, and finally, we start listening to the instrument.
conn.createInstrument('Exchange','CME-C','Product','CL',...
    'ProdType','Future','Contract','Sep13','Alias','CrudeOil')
conn.InstrNotify(1).AttachInstrument(conn.Instrument(1))

% Set events to obtain instrument updates
conn.InstrNotify(1).registerevent({'OnNotifyFound',@(varargin)ttinstrumentfound(varargin{:})})
conn.InstrNotify(1).registerevent({'OnNotifyNotFound',@(varargin)ttinstrumentnotfound(varargin{:})})
conn.InstrNotify(1).registerevent({'OnNotifyUpdate',@(varargin)ttinstrumentupdate(varargin{:},conn)})

% Only monitor these fields
conn.InstrNotify(1).UpdateFilter = 'Last$,LastQty$,~LastQty$,Change$';

% Start listening
conn.Instrument(1).Open(0) 

%% Display prices for 10 seconds, then shut down
% In this section, we pause for 10 seconds and then shut down our X_TRADER
% connection, so we won't get flooded with market information.
pause(10)
disp('Shutting down communications to X_Trader.')
close(conn)

