function sendOrderXT(signal)
%%SENDORDERXT submits an order to XTRADER
global x orderProfile
% Copyright 2010-2012, The MathWorks, Inc.

if isempty(x)
    %Start or connect to XTrader
    x = xtrdr;
    bServerUp = false;
    
    %Create an instrument
    x.createInstrument('Exchange','TTSIM-G','Product','IPE e-Brent','ProdType','Future','Contract','Oct12','Alias','Demo5c_OrderSubmitter');
    
    %Register event handler for order server
    sExchange = x.Instrument.Exchange;
    x.Gate.registerevent({'OnExchangeStateUpdate',@(varargin)ttorderserverstatus(varargin{:},sExchange)})
    
    %Create OrderSet
    x.createOrderSet;
    
    %Set order set properties and detail level of order status events
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
    
    %Enable send orders
    x.OrderSet(1).Open(1);
    
    assignin('base','x',x);
    
    %Build order profile with existing instrument
    orderProfile = x.createOrderProfile('Instrument',x.Instrument(1));
    
    %The code
    %
    % orderProfile = x.createOrderProfile;
    % orderProfile.Instrument = x.Instrument(1);
    %
    %performs the same task.
    
    %Set customer default property
    orderProfile.Customer = '<Default>';
    
    %Set up order profile as a market order to buy/sell shares
    orderProfile.Set('BuySell','Buy');
    orderProfile.Set('Qty','10');
    %orderProfile.Set('OrderType','M');
    orderProfile.Set('OrderType','L');
    orderProfile.Set('Limit$','110.0');

    assignin('base','orderProfile',orderProfile);
    %Check order server status before submitting order, added counter so that
    %demo never gets stuck
    nCounter = 1;
    while ~exist('bServerUp','var') && nCounter < 20
        %bServerUp is created by ttorderserverstatus
        pause(1)
        nCounter = nCounter + 1;
    end
    
end





if signal > 0
    orderProfile.Set('BuySell','Buy');
    orderProfile.Set('Limit$','110.0');
else
    orderProfile.Set('BuySell','Sell');
    orderProfile.Set('Limit$','120.0');
end

bServerUp = evalin('base','bServerUp');

if exist('bServerUp','var') && bServerUp
    %Submit the order
    submittedQuantity = x.OrderSet(1).SendOrder(orderProfile);
    disp(['Quantity Sent: '  num2str(submittedQuantity)])
else
    disp('Order server is down.  Unable to submit order.')
end

%To delete an order
%{
OrderObj = orderProfile.GetLastOrder;
if ~isempty(OrderObj)
  if ~OrderObj.IsNull
    OrderObj.DeleteOrder;
  end
end
%}

