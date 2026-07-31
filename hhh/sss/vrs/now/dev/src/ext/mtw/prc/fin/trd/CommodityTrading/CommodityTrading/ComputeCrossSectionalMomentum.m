function [ strategyRtn, bahRtn ] = ComputeCrossSectionalMomentum(params)
%COMPUTECROSSSECTIONALMOMENTUM Compute returns to cross-sectional momentum
%strategy on provided data.
% 
% params.DataContainer   Data on which strategy will be computed.
% params.LookbackWindow  How far to look back to compute momentum
% params.Indicator       Momentum indicator to use
% params.HowMany         How many commodities to pick at each step
% params.SkipPeriod      Months to skip before computing returns
% params.TxnCost         Trading frictions for each transaction

% Copyright 2013 The MathWorks, Inc.

% Extract parameters
container = params.DataContainer;
contractMonth = params.ContractMonth;
windowSize = params.LookbackWindow;
indicatorFcn = params.Indicator;
howMany = params.HowMany;
skipPeriod = params.SkipPeriod;
cost = params.TxnCost;

symbols = fields(container);
signal=[];allOpen=[];allClose=[];

% Compute indicator values for each commodity
for i=1:length(symbols)
    currSym = container.(symbols{i});
    
    ohlcData = currSym.Month{contractMonth};
    newSignal = indicatorFcn(ohlcData,windowSize);
    signal = [signal newSignal];
    allOpen = [allOpen ohlcData.Open];
    allClose = [allClose ohlcData.Close];
    dates=ohlcData.Date;
end

% Compute intra-period return
intraperiodRtn=(allClose - allOpen)./allOpen;

% Perform cross-sectional ranking of momentum
numCommodities=size(allOpen,2);
if numCommodities<2
    strategyRtn=[];
    bahRtn=[];
    return
end

lagMonths=skipPeriod;
[~,sortedIdx]=sort(signal,2);

pickedIndexValues=1:howMany;
pickedIndices=createLags(sortedIdx(:,pickedIndexValues),2);
for i=1:lagMonths
    pickedIndices(i,:)=pickedIndexValues;
end

% Extract intraperiod returns (long & short), add costs
cost = 20/10000; % basis points per round turn per position
rows=size(intraperiodRtn,1);
cols=howMany;
pickedRtns=zeros(rows,cols);
weights=zeros(rows,numCommodities);

% Compute returns
for i=(windowSize+lagMonths):rows
    for j=1:cols
        pickedRtns(i,j)=intraperiodRtn(i,pickedIndices(i,j))-cost;
    end
end

% Compute buy & hold and strategy returns, equally-wt'd
bahRtn=mean(intraperiodRtn,2);
strategyRtn=mean(pickedRtns,2);

end

