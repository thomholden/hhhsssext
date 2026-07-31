function [ CommodityData ] = GetCommodityBySymbol(source, symbol, contractMonth)
%GETCOMMODITYBYSYMBOL Extracts commodity dataset from container by symbol
%   source          Name of source container
%   symbol          Commodity symbol
%   contractMonth   Month number of contract if applicable 
%                   (front month=1, next month = 2, ..)

% Copyright 2013 The MathWorks, Inc.

    % Assume front month data is needed if not specified
    if nargin<3
        contractMonth=1; 
    end
    
    CommodityData=source.(symbol).Month{contractMonth};    

end

