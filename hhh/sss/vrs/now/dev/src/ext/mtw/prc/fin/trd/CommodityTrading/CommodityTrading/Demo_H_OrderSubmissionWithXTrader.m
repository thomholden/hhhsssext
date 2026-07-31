%% Commodities Trading with MATLAB - Order submission with X_TRADER
% Another important part of an analyst's workflow might be to connect to a
% trading platform for the purposes of submitting and monitoring trade
% orders. In this script, we connect to Trading Technologies' X_TRADER
% platform to create an order, submit it, monitor it, and finally, delete
% it.

% Copyright 2013 The MathWorks, Inc.

%% Setting up for order submission and monitoring
% Here, we set up our initial connection to the X_TRADER platform.
conn = xtrdr;

%% Create an instrument
% In this section we specify the instrument we will submit orders for.
conn.createInstrument('Exchange','CME-C',...
    'Product','CL','ProdType','Future',...
    'Contract','Sep13','Alias','CrudeOilOrder');

%% Register event handler for order server
% Next, we register an event handler function that will notify us if there
% is a change in the status of the order server.
sExchange = conn.Instrument.Exchange;
conn.Gate.registerevent({'OnExchangeStateUpdate',...
    @(varargin)ttorderserverstatus(varargin{:},sExchange)})

%% Create OrderSet
% In this section, we will create an order set and specify event handlers
% to notify us if an order is filled, rejected, submitted or deleted. 
conn.createOrderSet;

% Set order set properties and detail level of order status events
conn.OrderSet(1).EnableOrderRejectData = 1;
conn.OrderSet(1).EnableOrderUpdateData = 1;
conn.OrderSet(1).OrderStatusNotifyMode = 'ORD_NOTIFY_NORMAL';

% Set order set self-imposed position limit checks 
conn.OrderSet(1).Set('NetLimits',false)

%Set events to get status of order
conn.OrderSet(1).registerevent({'OnOrderFilled',@(varargin)ttorderevent(varargin{:},conn)})
conn.OrderSet(1).registerevent({'OnOrderRejected',@(varargin)ttorderevent(varargin{:},conn)})
conn.OrderSet(1).registerevent({'OnOrderSubmitted',@(varargin)ttorderevent(varargin{:},conn)})
conn.OrderSet(1).registerevent({'OnOrderDeleted',@(varargin)ttorderevent(varargin{:},conn)})

%%Enable send orders
conn.OrderSet(1).Open(1);

%% Build order profile with existing instrument 
% Here, we will build an order profile using the instrument we specified in
% an earlier section; our order profile will be a market order to buy 100
% contracts.
orderProfile = conn.createOrderProfile('Instrument',...
                    conn.Instrument(1));
orderProfile.Customer = '<Default>';

% Set up order profile as a market order to buy 100 units
orderProfile.Set('BuySell','Buy');
orderProfile.Set('Qty','100');
orderProfile.Set('OrderType','M');

% Limit order, set the ordertype and limit order price
% orderProfile.Set('OrderType','L');
% orderProfile.Set('Limit$','110.00');

%% Submit order
% Next, in this section, we first check the order server status and then
% proceed towards submitting the order.
nCounter = 1;
while ~exist('bServerUp','var') && nCounter < 20
  %bServerUp is created by ttorderserverstatus
  pause(1)
  nCounter = nCounter + 1;
end

if exist('bServerUp','var') && bServerUp
  %Submit the order
  submittedQuantity = conn.OrderSet(1).SendOrder(orderProfile);
  disp(['Quantity Sent: '  num2str(submittedQuantity)])
else
  disp('Order server is down.  Unable to submit order.')
end

%% To delete an order
% We get the last order submitted, and if it hasn't been executed yet (or
% has been partially filled), we can still go ahead and delete it.
OrderObj = orderProfile.GetLastOrder;
if ~isempty(OrderObj)
  if ~OrderObj.IsNull
    OrderObj.DeleteOrder;
  end
end

%% Shut down X_TRADER
% Once our trade order workflow has been completed, we can shut down our
% connection to X_TRADER.
disp('Shutting down communications to X_Trader.')
close(conn)