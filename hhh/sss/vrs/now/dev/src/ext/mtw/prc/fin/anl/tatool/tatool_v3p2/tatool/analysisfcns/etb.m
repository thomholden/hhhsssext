function out = etb(data,period,percent)
% Function to calculate the envelopes(trading bands) for a data series
% where a simple moving average is taken over the specified period and
% then moved up and down by the given percentage - for 5% enter 5 not 0.05
% 
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
% 'period' is the number of periods over which to calculate the average.
% (A simple moving average, see SMA, is used.)
% 'percent' is the percentage by which to move the SMA up and down.
%
% Example:
% out = etb(data,period,percent)
%

% Error check
if nargin ~= 3
    error([mfilename,' requires 3 inputs.']);
end
[m,n]=size(data);
if ~(m==1 || n==1)
    error(['The data input to ',mfilename,' must be a vector.']);
end
if (numel(period) ~= 1) || (mod(period,1)~=0)
    error('The period must be a scalar integer.');
end
if (numel(percent) ~= 1) || (percent <=0)
    error('The shift percent must be a positive scalar.');
end
if length(data) < period
    error('The length of the data must be at least the specified ''period''.');
end

if (n~=1)
    data = data(:);  % ensure we have a column
end

% calculate the SMA
smavg = sma(data,period);
% then shift it
out = [nan*ones(period-1,2);smavg(period:end)*(1+percent/100) smavg(period:end)*(1-percent/100)];