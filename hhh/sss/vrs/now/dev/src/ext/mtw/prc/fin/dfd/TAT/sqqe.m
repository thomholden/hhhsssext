
echo off


[date, close, open, low, high, volume, closeadj] ... 
      = StockQuoteQuery(smbl,'1-Jan-2003','31-Dec','d',2) ;

op(1:1: size(open,1),1)=open( size(open,1):-1:1,1);
hi(1:1:size(high,1),1)=high( size(high,1):-1:1,1);
lo(1:1:size(low,1),1)=low( size(low,1):-1:1,1);
cl(1:1:size(closeadj,1),1)=closeadj( size(closeadj,1):-1:1,1);
vol(1:1:size(volume,1),1)=volume( size(volume,1):-1:1,1);


fin_day=size(close,1);

for j=1:fin_day-1,
   help1(j)=j;
end
cl1=cl;

closeA=close;