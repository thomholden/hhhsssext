function out = wma(data,period)
% Function to calculate the weighted moving average of a data set
% The weight is based on the number of days in the moving average
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
% 'period' is the number of periods over which to calculate the average
%
% Example:
% wma(data,period)
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

% calculate the WMA
den = sum(1:period);
out = filter(period:-1:1,den,data);
out(1:period-1) = nan; % these are just the filter buffer filling