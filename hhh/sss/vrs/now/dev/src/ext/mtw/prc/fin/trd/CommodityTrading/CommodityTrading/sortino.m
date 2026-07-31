function [ ratio ] = sortino( Data, MAR )
%SORTINO Compute Sortino ratio. Wrapper around lpm function.
%   Data    Returns data.
%   MAR     Minimum Acceptable Return.

% Copyright 2013 The MathWorks, Inc.

if(nargin<2)
    MAR=0;
end

if size(Data,2)>1
    ratio=zeros(size(Data,2),1);
    for i=1:size(Data,2)
        ratio(i)=sortino(Data(:,i),MAR);
    end
else
    ratio = (mean(Data) - MAR) / sqrt(lpm(Data, MAR, 2));    
end


end

