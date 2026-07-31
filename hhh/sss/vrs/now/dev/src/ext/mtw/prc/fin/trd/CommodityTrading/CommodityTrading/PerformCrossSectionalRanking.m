% Copyright 2013 The MathWorks, Inc.

numCommodities=size(allOpen,2);
howMany=1;
lagMonths=2;
[sortedSignal,sortedIdx]=sort(signal,2);

pickedIndexValues=1:howMany;
pickedIndices=createLags(sortedIdx(:,pickedIndexValues),2);
for i=1:lagMonths
    pickedIndices(i,:)=pickedIndexValues;
end