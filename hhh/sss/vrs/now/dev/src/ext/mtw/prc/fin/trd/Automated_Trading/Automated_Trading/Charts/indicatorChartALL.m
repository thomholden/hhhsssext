function indicatorChartALL(price, names, signals)
%INDICATORCHARTALL A chart showing prices and trading signals sent from
% multiple strategies.
%
% Inputs are:
% PRICE: the price series of length numTicks
% NAMES: a cell array of strings of size 1-by-numNames
% SIGNALS: a matrix of size numTicks-by-numNames that corresponds to each
%  model's signal at each tick.
%
% Green indicates a long position, red a short position, and blue a neutral
% position.

% Copyright 2010-2012, The MathWorks, Inc.

ax(1) = subplot(2,1,1); plot(price);
grid on
ylabel('Price (USD)')
title('Price of LCO')
ax(2) = subplot(2,1,2); imagesc(signals')
cmap = colormap([1 0 0; 0 0 1; 0 1 0]);
ylabel('Strategy')
xlabel('Serial time number')
set(gca,'YTick',1:length(names),'YTickLabel',names);
title('Trade suggestions from different strategies')

linkaxes(ax,'x');
axis tight