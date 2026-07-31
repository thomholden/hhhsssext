function [ indicator ] = IndicatorROC( dataSet, lookback )
%INDICATORROC Measures rate of change over a given lookback period.
%   dataSet     Dataset array containing commodity OHLC data.
%   lookback    Size of lookback window.

% Copyright 2013 The MathWorks, Inc.

%% Extract vectors
AllClose=dataSet.Close;

%% Compute vectorized indicator
laggedData=lagmatrix(AllClose,lookback);
indicator=(AllClose-laggedData)./laggedData;
indicator(1:lookback)=0;

end

