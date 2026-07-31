function sendOrderQuickFIX(signal)
%%SENDORDERQUICKFIX submits an order to Banzai application
global banzai
% Copyright 2010-2012, The MathWorks, Inc.

%% Load in the relevant pacakages
import quickfix.*
import quickfix.examples.banzai.*
import quickfix.examples.banzai.ui.*

%% Start or connect to Banzai
if isempty(banzai)
    startBanzai('banzai.cfg');
    pause(5);
end
%% Create order object
o = Order;
FIX = banzai.initiator.getSessions;
o.setSessionID(FIX.get(2));
o.setSymbol('MW');
o.setQuantity(100);
o.setOpen(o.getQuantity)

if signal > 0
    o.setSide(OrderSide.parse('Buy'));
else
    o.setSide(OrderSide.parse('Sell'));
end

banzai.orderTable.addOrder(o)
banzai.application.send(o);






