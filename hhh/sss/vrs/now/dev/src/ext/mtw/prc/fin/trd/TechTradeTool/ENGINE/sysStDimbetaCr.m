function [tsSysOut, tsSysOutPlot] = sysStDimbetaCr(st, tsIn, idays1, idays2, kperiods, dperiods);

%tsIn=st.close;
tsInH=st.high;
tsInL=st.low;

[tsDim validFromDim] = dimbeta (tsIn,idays1);

% %Convert time series close to matrix
stclose2_mtx = tsIn;

% 
%Calculate Mov. Average of the Dimbeta 
[dmMovAv validFromAv] = movAv (tsDim, validFromDim, idays2);

%Calculate stochastic
[stochTsOut, validFromOutS] = stochast (tsInH, tsInL, tsIn, kperiods, dperiods, 'e');

%Construct time series object Signals
size1=size(tsDim);
signals=zeros(size1);


%Construct time series object tsSysIn
tsSysIn=[tsDim, dmMovAv, signals];


sign = 0;

size = size(tsSysIn);
tsDim2_mtx = tsSysIn(:,1);
dmMovAv2_mtx =tsSysIn(:,2);
signals2_mtx = tsSysIn(:,3);

%edo na doso stiles pinaka
tsSok2_mtx = stochTsOut(:,1);
tsSod2_mtx = stochTsOut(:,2);
%tsDate2_mtx=

if (validFromOutS>=validFromAv)
    validFromOut=validFromOutS;
 else
   validFromOut=validFromAv;
end


for (i = (validFromOut+1):size)
    
    d = tsDim2_mtx(i);
    movA = dmMovAv2_mtx(i);
    Ssok=tsSok2_mtx(i);
    Dsod=tsSod2_mtx(i);
    
    
    if(i>=2) 
        prevSsok = tsSok2_mtx(i-1);
        prevDsod = tsSod2_mtx(i-1);
        
        prev=signals2_mtx(i-1);
        signals2_mtx(i)=prev;
    end
     if   (Ssok > Dsod) & (prevSsok < prevDsod) & (d > movA)
          if (sign < 0)
            signals2_mtx(i) = 1;
          end        
         sign = 1;
     else if (Ssok < Dsod) & (prevSsok > prevDsod) & (d < movA)          
         if (sign > 0)
             signals2_mtx(i) = 0;
         end
         sign = -1;
     end
   
 end
end


%Calculate Performance of the system dimbeta 07/10/02
    tsSysOut.dim=tsDim2_mtx(validFromOut:end);
    tsSysOut.dmMovAv= dmMovAv2_mtx(validFromOut:end);
    tsSysOut.signals=signals2_mtx(validFromOut:end);
    tsSysOut.close=stclose2_mtx(validFromOut:end);
    tsSysOut.SOK=tsSok2_mtx(validFromOut:end);
    tsSysOut.SOD=tsSod2_mtx(validFromOut:end);
    dates=datenum(st.dates(validFromOut:end));
    
tsSysOut.difStoh= (tsSysOut.SOK-tsSysOut.SOD)./(tsSysOut.SOD);

tsSysOutPlot= fints(dates, [tsSysOut.close, tsSysOut.dim, tsSysOut.dmMovAv,tsSysOut.difStoh, tsSysOut.signals], {'Prices', 'Dimbeta', 'DmMovAv','difStoh', 'Signals'});
