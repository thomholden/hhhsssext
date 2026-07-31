function out = roc(data,period,format)
% Function to calculate the Rate-of-Change of a data set
% 'data' is the vector to operate on.  The first element is assumed to be
% the oldest data.
% 'period' is the number of periods over which to calculate the ROC
% 'format' is an optional input specifying 'percent' or 'points'.  The
% default is 'percent'.
%
% Example:
% out = roc(data,period,format)
%

% Error check
if nargin < 2
    error([mfilename,' requires at least 2 inputs.']);
elseif nargin < 3 
    format = 'percent';
end
if ~any(strcmp(format,{'percent','points'}))
    error('The format must be ''percent'' or ''points''.');
end
[m,n]=size(data);
if ~(m==1 || n==1)
    error(['The data input to ',mfilename,' must be a vector.']);
end
if numel(period) ~= 1
    error('The period must be a scalar.');
end
if length(data) < period+1
    error('The data set must be at least 1 element longer than the requested ROC period.');
end

% calculate ROC
out = nan*ones(size(data));
out(period+1:end) = data(period+1:end)-data(1:end-period);
if strcmp(format,'points')
    return;
end
%Otherwise put into percent format
out(period+1:end) = 100*(out(period+1:end)./data(1:end-period));