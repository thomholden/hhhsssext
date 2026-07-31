function [ childSet ] = FilterByContractNumber( parentSet, contractNum)
%FILTERBYCONTRACTNUMBER Filters a commodity data container by contract
%number (front month = 1, next month = 2, etc.)

% Copyright 2013 The MathWorks, Inc.
if (nargin<2)
    contractNum = 1;
end

childSet = struct;
symbols = fields(parentSet);

for i=1:length(symbols)
    currSym = parentSet.(symbols{i});
    childSet.(symbols{i})=struct;
    childSet.(symbols{i}).Month{contractNum} = currSym.Month{contractNum};
    childSet.(symbols{i}).Metadata = currSym.Metadata;
end
            
end

