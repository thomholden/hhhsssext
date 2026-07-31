function [ indicator ] = IndicatorSMADiff( dataSet, maPeriod )
%INDICATORSMADIFF Measures momentum by computing the ratio between a
%shorter MA and a longer MA.
%   dataSet     Dataset array containing commodity OHLC data.
%   maPeriod    Period of Moving Average to use.

% Copyright 2013 The MathWorks, Inc.

% Extract vectors
AllClose=dataSet.Close;
if(maPeriod<=10)
    Scale=2;
else
    Scale=10;
end

% Compute vectorized indicator
[smaShort,smaLong]=movavg(AllClose,maPeriod/Scale,maPeriod);
indicator=smaShort./smaLong - 1;
indicator(1:maPeriod)=0;

end

