function [ indicator ] = IndicatorSMASlope( dataSet, maPeriod )
%INDICATORSMASLOPE Measures momentum via the instantaneous slope of a
%Simple Moving Average of the closing price.
%   dataSet     Dataset array containing commodity OHLC data.
%   maPeriod    Period of Moving Average to use.

% Copyright 2013 The MathWorks, Inc.

% Extract vectors
AllClose=dataSet.Close;

% Compute vectorized indicator
[~,sma]=movavg(AllClose,1,maPeriod);
indicator=sma ./ lagmatrix(sma,1) -1;
indicator(1:maPeriod)=0;

end

