function out = bollingerul(data,period,nstd)
% Function to calculate the upper and lower bollinger bands for a vector
% of data.
% 
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
% 'period' is the number of periods over which to calculate the average.
% (A simple moving average, see SMA, is used.)
% 'nstd' is the number of standard deviations above/below the average to
% make the bands.
%
% Example:
% out = bollingerul(data,period,nstd)
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
if (numel(nstd) ~= 1) || (mod(nstd,1)~=0)
    error('The number of standard deviations must be a scalar integer.');
end
if length(data) < period
    error('The length of the data must be at least the specified ''period''.');
end

if (n~=1)
    data = data(:);  % ensure we have a column
end

% calculate the SMA
smavg = sma(data,period);
% calculate the std
stdw = nan*ones(size(data));
for idx = period:length(data)
    stdw(idx) = std(data(idx-period+1:idx));
end
out = [smavg+nstd*stdw  smavg-nstd*stdw];

if (n~=1)
    out = out';  % convert back to rows
end