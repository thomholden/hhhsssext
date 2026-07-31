function [ symbol ] = GetSymbolForName( metadataSet, name )
%GETSYMBOLFORNAME Returns stored symbol corresponding to commodity name.
%   metadataSet     Dataset containing commodity metadata.
%   name            Name of commodity.
%
% For example, searching for 'WTI' or 'WTI Crude' should return 'CL', while
% searching for 'Brent' should return 'BRN'.
% If there are multiple symbols corresponding to the string searched for,
% this will return the last symbol found.

% Copyright 2013 The MathWorks, Inc.

    indices=strfind(metadataSet.Commodity, name);
    
    for i=1:numel(indices)
        if cell2mat(indices(i))>0
            symbol = cell2mat(metadataSet.Symbol(i));
        end
    end
end

