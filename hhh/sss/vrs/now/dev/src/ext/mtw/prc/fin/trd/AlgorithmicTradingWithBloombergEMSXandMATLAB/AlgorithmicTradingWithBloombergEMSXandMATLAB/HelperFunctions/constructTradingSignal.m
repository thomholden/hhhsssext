function sig = constructTradingSignal(Data,M,N)

% Data is the resampled data from which to construct the signal.
% It has a column of dates/times and a column of prices
% M and N are the leading and lagging coefficients for the moving average

% Copyright 2010-2012, The MathWorks, Inc.
% All rights reserved.

% Author: Nicole Wilson, OPTI-NUM solutions, October 2013

% calculate moving average
[lead,lag] = movavg(Data,M,N);

% construct signal
s = zeros(size(Data,1),1);
s(lead > lag) = 1;
s(lead < lag) = -1;

% final signal is the last one
sig = s(end);
