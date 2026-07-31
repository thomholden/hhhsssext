%% X_Trader Order Submission Example
% This example shows how to create an order and submit it.    Note that X_Trader is a 32-bit application and will only
% work with 32-bit Windows installations of MATLAB.
%
%  Copyright 2012 The MathWorks, Inc.
%% Start or connect to XTrader
x = xtrdr;

%%Create an instrument
x.createInstrument('Exchange','TTSIM-G','Product','IPE e-Brent','ProdType','Future','Contract','Oct12','Alias','Demo5a_OrderSubmit');

%% Register event handler for order server
sExchange = x.Instrument.Exchange;
x.Gate.registerevent({'OnExchangeStateUpdate',@(varargin)ttorderserverstatus(varargin{:},sExchange)})

%% Create OrderSet
x.createOrderSet;

%%Set order set properties and detail level of order status events
x.OrderSet(1).EnableOrderRejectData = 1;
x.OrderSet(1).EnableOrderUpdateData = 1;
x.OrderSet(1).OrderStatusNotifyMode = 'ORD_NOTIFY_NORMAL';

%Set whether the order set checks self-imposed position limits when
%submitting an order
x.OrderSet(1).Set('NetLimits',false)

%Set events to get status of order
%The command
%
% events(x.OrderSet)
%
%shows the events associated with the OrderSet object
x.OrderSet(1).registerevent({'OnOrderFilled',@(varargin)ttorderevent(varargin{:},x)})
x.OrderSet(1).registerevent({'OnOrderRejected',@(varargin)ttorderevent(varargin{:},x)})
x.OrderSet(1).registerevent({'OnOrderSubmitted',@(varargin)ttorderevent(varargin{:},x)})
x.OrderSet(1).registerevent({'OnOrderDeleted',@(varargin)ttorderevent(varargin{:},x)})

%%Enable send orders
x.OrderSet(1).Open(1);

%%Build order profile with existing instrument 
orderProfile = x.createOrderProfile('Instrument',x.Instrument(1));

%The code
%
% orderProfile = x.createOrderProfile;
% orderProfile.Instrument = x.Instrument(1);
%
%performs the same task.

%Set customer default property
orderProfile.Customer = '<Default>';

%%Set up order profile as a market order to buy 100 shares
orderProfile.Set('BuySell','Buy');
orderProfile.Set('Qty','100');
%orderProfile.Set('OrderType','M');

%Limit order, set the ordertype and limit order price
%
orderProfile.Set('OrderType','L');
orderProfile.Set('Limit$','110.00');

%Stop market order, set the order restriction to stop order and stop price
%
% orderProfile.Set('OrderType','M');
% orderProfile.Set('OrderRestr','S');
% orderProfile.Set('Stop$','110.00');

%Stop limit order, set order restriction, type, limit price and stop price
%
% orderProfile.Set('OrderType','L');
% orderProfile.Set('OrderRestr','S');
% orderProfile.Set('Limit$','110.00');
% orderProfile.Set('Stop$','109.00');
%%
%Check order server status before submitting order, added counter so that
%demo never gets stuck
nCounter = 1;
while ~exist('bServerUp','var') && nCounter < 20
  %bServerUp is created by ttorderserverstatus
  pause(1)
  nCounter = nCounter + 1;
end

if exist('bServerUp','var') && bServerUp
  %Submit the order
  submittedQuantity = x.OrderSet(1).SendOrder(orderProfile);
  disp(['Quantity Sent: '  num2str(submittedQuantity)])
else
  disp('Order server is down.  Unable to submit order.')
end
%%
%To delete an order
OrderObj = orderProfile.GetLastOrder;
if ~isempty(OrderObj)
  if ~OrderObj.IsNull
    OrderObj.DeleteOrder;
  end
end

%%
disp('Shutting down communications to X_Trader.')
close(x)