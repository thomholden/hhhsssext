function [ childSet ] = FilterByType( parentSet, commodityType )
%FILTERBYTYPE Returns a container of commodity datasets of a particular
%type, such as 'Energy', 'Metal', 'Grain', etc.
%   parentSet       Name of parent data container. 
%   commodityType   Type of commodity.
%
% For example, one can extract training set data for all 'Energy'
% commodities or all 'Metal' commodities. If no commodity data exists for a
% particular type, an empty container is returned.

% Copyright 2013 The MathWorks, Inc.
childSet = struct;

symbols = fields(parentSet);

for i = 1:length(symbols)
    currSym = parentSet.(symbols{i});
    if strcmp(currSym.Metadata.Type,commodityType) % Same type
        childSet.(symbols{i}) = currSym;
    end
end
