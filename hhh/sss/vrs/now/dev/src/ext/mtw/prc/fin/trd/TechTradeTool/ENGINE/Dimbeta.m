%dimbeta calculation
function [tsOut, validFromOut] = dimbeta (tsIn, idays1);

[tsMovAv validFromAv] = movAv (tsIn, 1, idays1);
[r1 c1]=size(tsIn);

for i=1:r1
    tsOut(i) = (tsIn(i)-tsMovAv(i))./tsMovAv(i);
end
tsOut=tsOut';
validFromOut = validFromAv;

