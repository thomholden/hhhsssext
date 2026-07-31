% Copyright 2013 The MathWorks, Inc.

cost = 20/10000; % basis points per round turn per position
rows=size(intraperiodRtn,1);
cols=howMany;
pickedRtns=zeros(rows,cols);
weights=zeros(rows,numCommodities);

% Compute returns
for i=(windowSize+lagMonths):rows
    for j=1:cols
        pickedRtns(i,j)=intraperiodRtn(i,pickedIndices(i,j))-cost;
    end
end
