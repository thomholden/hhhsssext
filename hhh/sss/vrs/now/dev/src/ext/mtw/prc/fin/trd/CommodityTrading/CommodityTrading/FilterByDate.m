function [ childSet ] = FilterByDate( parentSet, fromDate, toDate )
%FILTERBYDATE Returns a new container of commodity data of the specified date range. 
%   parentSet       Container from which data is to be extracted.
%   fromDate        Starting date of filter (including this date).
%   toDate          Ending date of filter (including this date).
%
% Copyright 2013 The MathWorks, Inc.
childSet = parentSet;

symbols = fields(childSet);

for i = 1:length(symbols)
    currSym = childSet.(symbols{i});
    numMonths = length(currSym.Month);
    
    for j = 1:numMonths
        ds = currSym.Month{j};
        if (~isempty(ds))
            ds = ds(ds.Date >= datenum(fromDate) ...
                  & ds.Date <= datenum(toDate),:);
            currSym.Month{j} = ds;
        end
        clear ds;
    end
    
    childSet.(symbols{i}) = currSym;
end

end

