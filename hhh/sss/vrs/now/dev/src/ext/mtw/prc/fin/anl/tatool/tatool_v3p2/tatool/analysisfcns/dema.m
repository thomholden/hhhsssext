function out = dema(data,period)
% Function to calculate the double exponential moving average of a data set
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
% 'period' is the number of periods over which to calculate the average
%
% Example:
% out = dema(data,period)
%

% Error check
if nargin ~= 2
    error([mfilename,' requires 2 inputs.']);
end
[m,n]=size(data);
if ~(m==1 || n==1)
    error(['The data input to ',mfilename,' must be a vector.']);
end
if (numel(period) ~= 1)
    error('The period must be a scalar.');
end

% calculate the EMA
emavg = ema(data,period);
% calculate the EMA of the EMA
emaemavg = nan*ones(size(data));
emaemavg(period:end) = ema(emavg(period:end),period);
% calculate the double ema
out = 2*emavg-emaemavg;