function xt=ts1(xr,w);
%a la takens space for effective forecast of non-correlated sequences tau=w
%last point is xr(end) 
%w- the length of the analog in time series= dimension
%tau=1;%tau=w;
xr=xr(:);
xt=[];
for j=1:w,
    xt0=xr(end-j+1:-w:w-j+1);
    xt=[xt0(end:-1:1) xt];
end

   


