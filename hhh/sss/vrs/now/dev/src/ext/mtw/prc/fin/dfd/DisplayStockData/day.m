function dom = day(d)
% Return the day of the month, given a string date
c = datevec(datenum(d));
dom = c(3);
