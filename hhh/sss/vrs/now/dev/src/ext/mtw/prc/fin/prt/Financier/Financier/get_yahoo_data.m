function [X,dates] = get_yahoo_data(symbols, startDate, endDate, fieldName)
% download historic data for a bunch of symbols and align dates
% [X,dates] = get_yahoo_data(symbols, startDate, endDate, fieldName)
if nargin == 3
  fieldName = 'adj_close';
end

B = numel(symbols);
for i=1:B
  hst{i} = download_hist_yahoo_data(symbols{i},startDate, endDate);
end

%
% align dates
dates = hst{1}.dates;

for i=2:B
  dates = union(dates, hst{i}.dates);
end

X = zeros(length(dates),B);

for i =1:B
  X(:,i) = interp1(hst{i}.dates, hst{i}.(fieldName), dates);
end
