function [tsSysOut, tsSysOutPlot] = sysDimbetaStoh(st, tsIn ,idays1, idays2, kperiods, dperiods);

% tsIn=st.close;
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

[size2 col] = size(tsSysIn);
disp(size2);

if (validFromOutS>=validFromAv)
    validFromOut=validFromOutS;
 else
   validFromOut=validFromAv;
end
size2b=size2-validFromOut+1;
disp(size2b);

tsDim2_mtx = tsSysIn(validFromOut:end,1);
dmMovAv2_mtx =tsSysIn(validFromOut:end,2);
signals2_mtx = tsSysIn(validFromOut:end,3);
disp(size(tsDim2_mtx));
% disp(signals2_mtx);

%edo na doso stiles pinaka
tsSok2_mtx = stochTsOut(validFromOut:end,1);
tsSod2_mtx = stochTsOut(validFromOut:end,2);
%tsDate2_mtx=


signals2_mtx(1)=0;

for (i = 2:size2b)
    
    d = tsDim2_mtx(i);
    movA = dmMovAv2_mtx(i);
    Ssok=tsSok2_mtx(i);
    Dsod=tsSod2_mtx(i);
    
    
   
        prevD = tsDim2_mtx(i-1);
        prevMovA = dmMovAv2_mtx(i-1);
        prev=signals2_mtx(i-1);
        signals2_mtx(i)=prev;
        

     if (d > movA)  & (Ssok > Dsod) 
          if (sign <= 0)
            signals2_mtx(i) = 1;
          end        
         sign = 1;
     else if (d < movA) & (Ssok < Dsod)            
         if (sign > 0)
             signals2_mtx(i) = 0;
         end
         sign = -1;
     end
   
 end
end

%Calculate Performance of the system dimbeta 07/10/02


    tsSysOut.dim=tsDim2_mtx;
    tsSysOut.dmMovAv= dmMovAv2_mtx;
    tsSysOut.signals=signals2_mtx;
    tsSysOut.close=stclose2_mtx(validFromOut:end);
    tsSysOut.SOK=tsSok2_mtx;
    tsSysOut.SOD=tsSod2_mtx;
    dates=datenum(st.dates(validFromOut:end));

tsSysOut.difStoh= (tsSysOut.SOK-tsSysOut.SOD)./(tsSysOut.SOD);
disp(size(tsSysOut.dim));
disp(size(tsSysOut.dmMovAv));
disp(size(tsSysOut.close));
disp(size(tsSysOut.SOK));
disp(size(tsSysOut.SOD));

disp(size(tsSysOut.signals));
disp(size(dates));

tsSysOutPlot= fints(dates, [tsSysOut.close, tsSysOut.dim, tsSysOut.dmMovAv,tsSysOut.difStoh, tsSysOut.signals], {'Prices', 'Dimbeta', 'DmMovAv','difStoh', 'Signals'});
