function pairsChart(LCO, WTI)
% PAIRSCHART: Shows the full time history for LCO and WTI

% Copyright 2010-2012, The MathWorks, Inc.

plot(LCO(:,1), LCO(:,4), WTI(:,1), WTI(:,4))

datetick('x')
grid on

xlabel('Date')
ylabel('Price (USD)')

title('Intraday prices for LCO and WTI')
legend('LCO', 'WTI', 'Location', 'best')