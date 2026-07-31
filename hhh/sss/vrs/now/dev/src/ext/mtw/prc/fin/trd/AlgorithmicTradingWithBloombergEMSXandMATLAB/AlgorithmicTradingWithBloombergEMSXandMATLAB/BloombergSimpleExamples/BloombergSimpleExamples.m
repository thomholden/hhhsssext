%% Bloomberg EMSX API: Simple Examples 
% This script will demonstrate some simple examples related to creating,
% routing and managing orders from MATLAB via Bloomberg EMSX. 

%  Author: Nicole Wilson, OPTI-NUM solutions, October 2013
%  Please email nicole@optinum.co.za with any comments

%% Preliminary Tasks
% Before creating, managing or routing orders via Bloomberg EMSX, the
% following preliminary tasks must be completed.

%% 
% *Add BLPAPI3.jar to java class path*
% The set up for the Bloomberg API is very simple. All it requires is that
% a cerain JAR file is added to the Java path.
% This only needs to be done once per MATLAB session. Alternatively, the 
% JAR file can be added to the static Java path, which only needs to be done
% once. 
javaaddpath('C:\blp\API\blpapi3.jar')

%%
% *Connect to the EMSX API Production Server*
% c = emsx('//blp/emapisvc');
% 
% *Connect to EMSX API Test Server*
% This creates a Bloomberg EMSX connection object.
c = emsx('//blp/emapisvc_beta');

%% 1. Create a Buy Order
% To create an order, you must first create a structure with the
% required fields (the field requirements change depending on the broker,
% as well as certain field values that prompt for additional information). 
% Following the creation of the order structure, you can use the function
% "createOrder" with this structure as an input argument.

%%
% Create a structure to hold order information
longStruct.EMSX_SIDE = 'BUY'; 
longStruct.EMSX_AMOUNT = int32(500); % faster to enter these as "int32" data types
longStruct.EMSX_TICKER = char('BGA'); % faster to enter these as "char" data types
longStruct.EMSX_ORDER_TYPE = 'MKT'; 
longStruct.EMSX_BROKER = 'BB'; % BB is the Bloomberg test broker
longStruct.EMSX_TIF = 'GTD'; % Good til Date
longStruct.EMSX_GTD_DATE = int32(20130903);% NB. Dates entered in this format (yyyymmdd)
longStruct.EMSX_HAND_INSTRUCTION = 'ANY'; 

%%
% Create order
% rlongOrder is a structure containing an EMSX Sequence number and a message telling 
% you whether the order creation has been successful or not.

rlongOrder = createOrder(c,longStruct);

%% 3. Create a Sell Order
% This process is the same as before, except this time, we are creating the
% order on the sell side. We will send the order to a different test
% broker, the broker "API".

%%
% Create a structure to hold order information
shortStruct.EMSX_SIDE = 'SELL'; 
shortStruct.EMSX_AMOUNT = int32(300); 
shortStruct.EMSX_TICKER = char('NED');
shortStruct.EMSX_ORDER_TYPE = 'MKT'; 
shortStruct.EMSX_BROKER = 'API'; % API is one of Bloomberg's test brokers
shortStruct.EMSX_TIF = 'DAY'; % Order will persist until the end of the day
shortStruct.EMSX_HAND_INSTRUCTION = 'ANY'; 

%%
% Create order
rshortOrder = createOrder(c,shortStruct)

%% 4. Get Order Information

% Long order
longOrderInfo = getOrderInfo(c,rlongOrder.EMSX_SEQUENCE);

% Short order
shortOrderInfo = getOrderInfo(c,rshortOrder.EMSX_SEQUENCE);

%% 5. Modify an Order
% To make changes to an existing order, you need to know the EMSX sequence
% number for the order you wish to modify.

%%
% Create a new structure with the details of the modified order
% There are certain things you can modify and certain things you cannot.
% For instance, you can change the amount, but not the ticker, the broker
% or the strategy.
modStruct.EMSX_SEQUENCE = int32(rshortOrder.EMSX_SEQUENCE); % EMSX sequency number of order you want to change
modStruct.EMSX_TICKER = char('NED'); % Ticker of short order
modStruct.EMSX_AMOUNT = int32(200); % Change amount to 200
rmodifiedOrder = modifyOrder(c,modStruct)

% Modified order
modifiedOrderInfo = getOrderInfo(c,rmodifiedOrder.EMSX_SEQUENCE)

%% 6. Delete an Order
% To delete an order, you need to know the EMSX sequence number of the
% order.

% Create a new structure with the details of the order to delete
delStruct.EMSX_SEQUENCE = rmodifiedOrder.EMSX_SEQUENCE;
rdeletedOrder = deleteOrder(c,delStruct)

%% 7. Route an Order
% Use existing order structure to create a new structure to route to the
% broker. The creation of an order and routing can be done in one step,
% using the function createOrderAndRoute

routeStructLong.EMSX_AMOUNT = longStruct.EMSX_AMOUNT;
routeStructLong.EMSX_SEQUENCE = rlongOrder.EMSX_SEQUENCE;
routeStructLong.EMSX_TICKER = longStruct.EMSX_TICKER;
routeStructLong.EMSX_ORDER_TYPE = longStruct.EMSX_ORDER_TYPE;
routeStructLong.EMSX_BROKER = longStruct.EMSX_BROKER;% BB broker
routeStructLong.EMSX_TIF = longStruct.EMSX_TIF;
routeStructLong.EMSX_GTD_DATE = longStruct.EMSX_GTD_DATE;
routeStructLong.EMSX_HAND_INSTRUCTION = longStruct.EMSX_HAND_INSTRUCTION;

rrouteOrderLong = routeOrder(c,routeStructLong); 

%% 9. Route an Order with a Strategy
% As a variation on the above, you can create an order structure, and then
% route the order with a strategy. For each broker, there are a number of
% strategies to choose from. You can create the order and route it with a
% strategy in one step.

% clear old shortStruct
clear shortStruct

%%
% Create a structure to hold order information
shortStruct.EMSX_SIDE = 'SELL'; 
shortStruct.EMSX_AMOUNT = int32(300); 
shortStruct.EMSX_TICKER = char('FSR'); 
shortStruct.EMSX_ORDER_TYPE = 'MKT'; 
shortStruct.EMSX_BROKER = 'API';
shortStruct.EMSX_TIF = 'DAY'; 
shortStruct.EMSX_HAND_INSTRUCTION = 'ANY'; 

%%
% Find out what strategies are available for this ticker
brokerStruct.EMSX_BROKER = 'API';
brokerStruct.EMSX_TICKER = char('FSR');

strategies = getBrokerInfo(c,brokerStruct);
strategies.EMSX_STRATEGIES

%%
% Choose the TWAP strategy and have a look at what fields are required.
% Executes an order in equally-sized slices over a specified time interval 
% to achieve a time-weighted average execution price
brokerStruct.EMSX_STRATEGY = 'TWAP';

%%
% Information about required fields
fields = getBrokerInfo(c,brokerStruct)
fields.FieldName % FIELDS: StartTime, EndTime, Max%Volume, MinCrossQty, MaxCrossQty, CrossLmtPx, AgencyOnly

stratStruct.EMSX_STRATEGY_NAME = 'TWAP';
stratStruct.EMSX_STRATEGY_FIELD_INDICATORS = int32([0 0 0 0 0 0 0]);
stratStruct.EMSX_STRATEGY_FIELDS = {'09:30:00','09:35:00',50,10,50,10,'Yes'}

%%
% create order and route with strategy
rshortOrderWithStrat = createOrderAndRouteWithStrat(c,shortStruct,stratStruct);

%% 
% Similarly, you can modify a route, modify a route with a strategy, and
% delete a route, if it has not already been filled.

%% Post-trade Tasks
%%
% *Close the Bloomberg EMSX Connection*

close(c)
