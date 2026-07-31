function []=ComputeBacktestAndPlot(container)
%%COMPUTEBACKTESTANDPLOT Backtests a trend following strategy on the 
%specified container of data, and plots the result.

% Copyright 2013 The MathWorks, Inc.

% Parameters
lookbackArray = [10 20 40 80];
holdingPeriod = 100;

% Set up plotting
clf;

% Set up loops and aggregators
ctr = 1;
summary = [];worst = [];best = [];
symbols = fields(container);

% Main loop
for lookback = lookbackArray
    h = subplot(numel(lookbackArray)/2,2,ctr);
    allComms = [];
    for i = 1:length(symbols)
        currSym = container.(symbols{i});
        numMonths = length(currSym.Month);
        
        for j = 1:numMonths
            ohlc = currSym.Month{j};
            % Set up lookback window and holding period window
            laggedHigh=max(createLags(ohlc.High,1:lookback),[],2);
            fwdClose=createLags(ohlc.Close,-(1:holdingPeriod));
            % Remove NaNs
            nans=any([isnan(fwdClose) isnan(laggedHigh)],2);
            laggedHigh(nans)=0;
            fwdClose(nans)=0;
            % Compute signal; lag by 1 to trade from next period open
            signal=createLags(ohlc.Close > laggedHigh,1);
            signal(nans)=0;
            signal=any(signal,2);
            % Compute holding period returns; 
            % average across trades;
            % aggregate across products
            fwdRtnSeries=fwdClose .* repmat(signal,1,holdingPeriod) ...
                        ./repmat(ohlc.Open.*signal,1,holdingPeriod);
            avgRtnSeries=nanmean(fwdRtnSeries);
            allComms=[allComms; avgRtnSeries];
        end
        % Plot avg performance across multiple trades for current product
        plot(h,100*avgRtnSeries);
        title(gca,[sprintf('%3i',lookback) ' periods']);
        hold all;
    end

    ctr=ctr+1;
    range=1:holdingPeriod;
    worst=[worst; min(allComms(:,range))];
    summary=[summary; median(allComms(:,range))];
    best=[best; max(allComms(:,range))];
end

end