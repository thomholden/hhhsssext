% Copyright 2013 The MathWorks, Inc.

indicatorFcn=@IndicatorSMASlope;

windowSize=6;

symbols = fields(container);
signal=[];allOpen=[];allClose=[];

% Compute indicator values for each commodity
for i=1:length(symbols)
    currSym = container.(symbols{i});
    ohlcData = currSym.Month{1};
    newSignal = indicatorFcn(ohlcData,windowSize);
    signal = [signal newSignal];
    allOpen = [allOpen ohlcData.Open];
    allClose = [allClose ohlcData.Close];
    dates=ohlcData.Date;
end

% Compute intra-period return
intraperiodRtn=(allClose - allOpen)./allOpen;
