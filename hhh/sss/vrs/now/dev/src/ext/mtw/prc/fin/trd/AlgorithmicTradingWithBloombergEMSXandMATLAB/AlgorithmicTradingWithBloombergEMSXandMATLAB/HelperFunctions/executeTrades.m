function executeTrades(c, equity, signal)

% input arguments are:
% * c: Bloomberg connection object
% * equity: ticker symbol for Bloomberg equity
% * signal: buy (1), sell (-1)

% Author: Nicole Wilson, OPTI-NUM solutions, October 2013

%% Act on next tick price
%% 
% Construct reqStruct

reqStruct.EMSX_TICKER = char(equity);
reqStruct.EMSX_AMOUNT = int32(1);
reqStruct.EMSX_ORDER_TYPE = 'MKT';
reqStruct.EMSX_BROKER = 'BB';
reqStruct.EMSX_TIF = 'DAY';
reqStruct.EMSX_HAND_INSTRUCTION = 'ANY';
if signal == 1
    reqStruct.EMSX_SIDE = 'BUY';
elseif signal == -1
    reqStruct.EMSX_SIDE = 'SELL';
end

%%
% Execute Order

createOrder(c,reqStruct); 

%% Close off trade
%%
% Construct reqStruct
reqStruct.EMSX_TICKER = char(equity);
reqStruct.EMSX_AMOUNT = int32(1);
reqStruct.EMSX_ORDER_TYPE = 'MKT';
reqStruct.EMSX_BROKER = 'BB';
reqStruct.EMSX_TIF = 'DAY';
reqStruct.EMSX_HAND_INSTRUCTION = 'ANY';
if signal == -1
    reqStruct.EMSX_SIDE = 'BUY';
elseif signal == 1
    reqStruct.EMSX_SIDE = 'SELL';
end

%%
% Execute Order

createOrder(c,reqStruct); 
