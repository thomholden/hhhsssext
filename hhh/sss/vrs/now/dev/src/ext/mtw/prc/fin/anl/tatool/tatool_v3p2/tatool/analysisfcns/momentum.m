function out = momentum(data,period)
% Function to calculate the Momentum of a data set
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
% 'period' is the number of periods over which to calculate the momentum
%
% Example:
% out = momentum(data,period)
%

% Error check
if nargin ~= 2
    error([mfilename,' requires 2 inputs.']);
end
[m,n]=size(data);
if ~(m==1 || n==1)
    error(['The data input to ',mfilename,' must be a vector.']);
end
if numel(period) ~= 1
    error('The period must be a scalar.');
end
if length(data) < period+1
    error('The data set must be at least 1 element longer than the requested momentum period.');
end

% calculate momentum
out = nan*ones(size(data));
out(period+1:end) = 100*(data(period+1:end)./data(1:end-period));