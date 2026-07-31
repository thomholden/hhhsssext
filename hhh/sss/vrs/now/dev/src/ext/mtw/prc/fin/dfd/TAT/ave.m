


val0 = get(hpop0,'Value');

if val0 == 2   
   days=20;
elseif val0 == 3
   days=40;
elseif val0 == 4 
   days=80;
elseif val0 == 5
   days=120;
elseif val0 == 6  
   days=180;
elseif val0 == 7 
   days=200;
elseif val0 == 8
   days=220;    
 end

 w=0;
 for j=fin_day-days:fin_day-1,
   w=w+1;
   help1(w)=j;
end



val1 = get(hpop1,'Value');

if val1 == 2   
   s=2;
elseif val1 == 3
   s=5;
elseif val1 == 4 
   s=7;
elseif val1 == 5
   s=10;
elseif val1 == 6  
   s=15;
elseif val1 == 7 
   s=20;
elseif val1 == 8
   s=30;    
elseif val1 == 9
   s=35;  
 end

val2 = get(hpop2,'Value');

if val2 == 2   
   f=2;
elseif val2 == 3
   f=5;
elseif val2 == 4 
   f=7;
elseif val2 == 5
   f=10;
elseif val2 == 6  
   f=15;
elseif val2 == 7 
   f=20;
elseif val2 == 8
   f=30;    
elseif val2 == 9
   f=35;  
end

figure(1),
subplot(611)
BOLLING(closeA(fin_day-days:fin_day-1),10,1)
axis([0 days, min(closeA(fin_day-days:fin_day-1))-1 max(closeA(fin_day-days:fin_day-1))+1])
grid on;zoom on;
title('Bollinger',...
    'FontSize',10,...
    'FontWeight', 'bold')   
axis tight
clear cl2;
clear help1;
clear w;   

subplot(612)
MOVAVG(closeA(fin_day-days:fin_day-1),s,f,0)
axis([0 days, min(closeA(fin_day-days:fin_day-1))-1 max(closeA(fin_day-days:fin_day-1))+1])
axis tight
title('Simple moving average',...
    'FontSize',10,...
    'FontWeight', 'bold')   
grid on;zoom on;
clear cl2;
clear help1;
clear w;   
   
subplot(613)
MOVAVG(closeA(fin_day-days:fin_day-1),s,f,0.5)
axis([0 days, min(closeA(fin_day-days:fin_day-1))-1 max(closeA(fin_day-days:fin_day-1))+1])
axis tight
title('Square root weighted moving average',...
    'FontSize',10,...
    'FontWeight', 'bold')   
grid on;zoom on;
clear cl2;
clear help1;
clear w;   
   
   
subplot(614)
MOVAVG(closeA(fin_day-days:fin_day-1),s,f,1)
axis([0 days, min(closeA(fin_day-days:fin_day-1))-1 max(closeA(fin_day-days:fin_day-1))+1])
axis tight
title('Linear moving average',...
    'FontSize',10,...
    'FontWeight', 'bold')   
grid on;zoom on;
clear cl2;
clear help1;
clear w;   
   
subplot(615)
MOVAVG(closeA(fin_day-days:fin_day-1),s,f,2)
axis([0 days, min(closeA(fin_day-days:fin_day-1))-1 max(closeA(fin_day-days:fin_day-1))+1])
axis tight
title('Square weighted moving average',...
    'FontSize',10,...
    'FontWeight', 'bold')   
grid on;
zoom on;
clear cl2;
clear help1;
clear w;   
   
subplot(616)
MOVAVG(closeA(fin_day-days:fin_day-1),s,f,'e')
axis([0 days, min(closeA(fin_day-days:fin_day-1))-1 max(closeA(fin_day-days:fin_day-1))+1])
axis tight
title('Exponential moving averages',...
    'FontSize',10,...
    'FontWeight', 'bold')         
zoom on;
grid on;
clear cl2;
clear help1;
clear w;   

