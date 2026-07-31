function out = dpo(data,period)
% Function to calculate the detrended price oscillator of a data set.
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
% 'period' is the number of periods over which to calculate the indicator
%
% Example:
% out = dpo(data,period)
%

% Error check
if nargin ~= 2
    error([mfilename,' requires 2 inputs.']);
end
[m,n]=size(data);
if ~(m==1 || n==1)
    error(['The data input to ',mfilename,' must be a vector.']);
end
if (numel(period) ~= 1) || (mod(period,1)~=0)
    error('The period must be a scalar integer.');
end
if length(data) < period
    error('The length of the data must be at least the specified ''period''.');
end

% Firstly calculate the SMA
smavg = sma(data,period);
% Move the data back (period/2)+1 periods
offset = floor(period/2+1);
% calculate the dpo
ld = length(data);
out = nan*ones(ld,1);
out(period-offset:ld-offset)= data(period-offset:ld-offset)-smavg(period:end);