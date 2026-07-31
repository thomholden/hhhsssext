function startBanzai(configFile)

global banzai
% Copyright 2010-2012, The MathWorks, Inc.


%% Load in the relevant pacakages
import quickfix.*
import quickfix.examples.banzai.*
import quickfix.examples.banzai.ui.*

%% Start up Banzai
% Set up in MATLAB the example application, Banzai.  This is a order entry
% interface.
banzai.settings = SessionSettings(configFile);
banzai.storeFactory = FileStoreFactory(banzai.settings);
banzai.logFactory = ScreenLogFactory(true,true,true,true);
banzai.messageFactory = DefaultMessageFactory();
banzai.orderTable = OrderTableModel;
banzai.execTable = ExecutionTableModel;
banzai.application = BanzaiApplication(banzai.orderTable,banzai.execTable);
banzai.initiator = SocketInitiator(banzai.application,banzai.storeFactory,banzai.settings,banzai.logFactory,banzai.messageFactory);
banzai.frame = BanzaiFrame(banzai.orderTable,banzai.execTable,banzai.application);
banzai.initiator.start;



