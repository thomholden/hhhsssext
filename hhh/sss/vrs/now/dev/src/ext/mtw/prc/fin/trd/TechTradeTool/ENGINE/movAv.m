function [tsOut, validFromOut] = movAv (tsIn, validFromIn, iDays);

tsOut = tsmovavg (tsIn, 's', (iDays-1), 0,1);

validFromOut = validFromIn + iDays - 1;

%tsOut = chfield (st, 'series1', 'high');