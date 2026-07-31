function [performance, plCalcTable, numTrades, trades] = sysPerf (tsSysOut, initialCap);
% 
% addpath('engine');
% addpath('ui');
%  
% [tsDim validFromDim] = dimbeta (tsIn,idays1);
% 
% %Convert time series close to matrix
% stclose2_mtx = tsIn;
% 
% % 
% %Calculate Mov. Average of the Dimbeta 
% [dmMovAv validFromAv] = movAv (tsDim, validFromDim, idays2);
% 
% 
% %Construct time series object Signals
% size1=size(tsDim);
% signals=zeros(size1);
% 
% 
% %Construct time series object tsSysIn
% tsSysIn=[tsDim, dmMovAv, signals];
 
%Call sysDimbeta
% [tsSysOut validFromOut] = sysDimbeta(tsIn, validFromAv);
% plot(tsSysOut(validFromAv:end));
% tsSysOut2=tsSysOut(validFromAv:end);
% 
%Calculate Performance of the system dimbeta
signals2_mtx = tsSysOut.signals;

%construct table Profit-Loss
stclose2_mtx =tsSysOut.close; 

%tsSysOut2=tsSysOut((validFromOut:end),:);


size3=size(signals2_mtx);

numStock=zeros(size3);
equity(1:size3)=initialCap;
profit=zeros(size3);
equity=equity';


signals2_mtx(1)=0;
for (i=2:size3)
    
    scurrent = signals2_mtx(i);
    sprevious = signals2_mtx(i-1);
    
    if (scurrent == 1) & (sprevious==0)
        numStock(i)=equity(i-1)/(stclose2_mtx(i)*(1.02));
        equity(i)=stclose2_mtx(i)*numStock(i);
    end

    if (scurrent == 1) & (sprevious==1)
        numStock(i)=numStock(i-1);
        equity(i)=stclose2_mtx(i)*numStock(i);
    end
    
    if (scurrent == 0) & (sprevious==1)
        numStock(i)=numStock(i-1);
        equity(i)=stclose2_mtx(i)*numStock(i);
    end
    
    if (scurrent == 0) & (sprevious==0)
        numStock(i)=0;
        equity(i)=equity(i-1);
    end
  
    
 profit(i)=equity(i)-equity(i-1);
end
performance=(sum(profit))/equity(1);

plCalcTable=[signals2_mtx, stclose2_mtx, numStock, equity, profit];


A=0;
B=0;
j=0;
for (i=2:size3)
    
    scurrent =signals2_mtx(i);
    sprevious = signals2_mtx(i-1);
   
    if (scurrent ==1) & (sprevious==0)
        A=i;
    end
    
    if (scurrent == 0) & (sprevious ==1)
        B=i;
    end         
    
        if (A ~= 0) & (B ~= 0)
            j=j+1;
            trades(j)=sum(profit(A:B));
            A=0;
            B=0;
        end
end
% 
% disp(size(profit));    
% disp((trades));

trades=trades';
[numTrades c]=size(trades);
