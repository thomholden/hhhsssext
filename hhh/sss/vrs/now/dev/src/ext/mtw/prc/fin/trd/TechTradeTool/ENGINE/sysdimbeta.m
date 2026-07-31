function [tsSysOut, tsSysOutPlot] = sysDimbeta (st, tsIn, idays1, idays2);

%tsIn=st.close;
 
[tsDim validFromDim] = dimbeta (tsIn,idays1);

% %Convert time series close to matrix
stclose2_mtx = tsIn;

% 
%Calculate Mov. Average of the Dimbeta 
[dmMovAv validFromAv] = movAv (tsDim, validFromDim, idays2);


%Construct time series object Signals
size1=size(tsDim);
signals=zeros(size1);


%Construct time series object tsSysIn
tsSysIn=[tsDim, dmMovAv, signals];




sign = 0;

[size2 col] = size(tsSysIn);
validFromOut=validFromAv;

size2b=size2-validFromOut+1;


tsDim2_mtx = tsSysIn(validFromOut:end,1);
dmMovAv2_mtx =tsSysIn(validFromOut:end,2);
signals2_mtx = tsSysIn(validFromOut:end,3);
disp(size(tsDim2_mtx));


signals2_mtx(1)=0;
for (i = 2:size2b)
    
    d = tsDim2_mtx(i);
    movA = dmMovAv2_mtx(i);
    
    
        prev=signals2_mtx(i-1);
        signals2_mtx(i)=prev;
    
     if d > movA  
         if (sign <= 0)
            signals2_mtx(i) = 1;
         end        
         sign = 1;
     else if (d < movA)            
         if (sign >= 0)
             signals2_mtx(i) = 0;
         end
         sign = -1;
     end
   
 end
end
% tsSysOut=[tsDim2_mtx, dmMovAv2_mtx ,signals2_mtx];

tsSysOut.dim=tsDim2_mtx;
tsSysOut.dmMovAv= dmMovAv2_mtx;
tsSysOut.signals=signals2_mtx;
tsSysOut.close=stclose2_mtx(validFromAv:end);

% tsSysOutPlot, 

dates=datenum(st.dates(validFromAv:end));
tsSysOutPlot= fints(dates, [tsSysOut.close, tsSysOut.dim, tsSysOut.dmMovAv, tsSysOut.signals], {'Prices', 'Dimbeta', 'DmMovAv', 'Signals'});
