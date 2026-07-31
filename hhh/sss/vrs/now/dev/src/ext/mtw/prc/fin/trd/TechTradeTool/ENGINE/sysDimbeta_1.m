function [tsSysOut, tsSysOutPlot] = sysDimbeta_1(st, idays1, idays2);

tsIn=st.close;
 
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

size= size(tsSysIn);
tsDim2_mtx = tsSysIn(:,1);
dmMovAv2_mtx =tsSysIn(:,2);
signals2_mtx = tsSysIn(:,3);

%This for plot signals
signals3_mtx(1:size)=0;
signals3_mtx=signals3_mtx';

for (i = 1:size)
    
    d = tsDim2_mtx(i);
    movA = dmMovAv2_mtx(i);
    
    if(i>=2) 
        prev=signals2_mtx(i-1);
        signals2_mtx(i)=prev;
        
        prev3=signals3_mtx(i-1);
        signals3_mtx(i)=prev3;

    end
     if d > movA  
          if (sign < 0)
            signals2_mtx(i) = 1;
            signals3_mtx(i) = 1;
          end        
         sign = 1;
     else if (d < movA)            
         if (sign > 0)
             signals2_mtx(i) = 0;
             signals3_mtx(i) = -1;
         end
         sign = -1;
     end
   
 end
end
% tsSysOut=[tsDim2_mtx, dmMovAv2_mtx ,signals2_mtx];

tsSysOut.dim=tsDim2_mtx(validFromAv:end);
tsSysOut.dmMovAv= dmMovAv2_mtx(validFromAv:end);
tsSysOut.signals=signals2_mtx(validFromAv:end);
tsSysOut.close=stclose2_mtx(validFromAv:end);

% tsSysOutPlot, 

dates=datenum(st.dates(validFromAv:end));
tsSysOutPlot= fints(dates, [tsSysOut.close, tsSysOut.dim, tsSysOut.dmMovAv, signals3_mtx(validFromAv:end)], {'Prices', 'Dimbeta', 'DmMovAv', 'Signals'});
