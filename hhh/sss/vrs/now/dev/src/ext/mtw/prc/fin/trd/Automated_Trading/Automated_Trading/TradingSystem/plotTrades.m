function plotTrades(tradeSignal,securityData)

%% Create plot
ax(1) = subplot(2,1,1);
plot(securityData(:,3));
ylabel('Close Price')

ax(2) = subplot(2,1,2);
plot(tradeSignal);
axlim = axis;
axis([axlim(1:2), -0.1 1.1])
linkaxes(ax,'x')
xlabel('Number of Ticks in Window')
%ylabel('Trading Signal')

% Copyright 2010-2012, The MathWorks, Inc.
