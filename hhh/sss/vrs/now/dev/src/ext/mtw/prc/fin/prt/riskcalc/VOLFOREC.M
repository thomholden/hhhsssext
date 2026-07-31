% Volatility forecasts using MA and exponential algorithms
% (c) by A. Ivanov
global Asset Wts
N=size(Asset,1);
if N<1
   msgbox('Please load stock data file!','Error')
   return
end;
% Read fields
ui_handles = get(gcf,'UserData');
ticker  = get(ui_handles(1),'String');
lb  = str2num(get(ui_handles(2),'String'));
hb  = str2num(get(ui_handles(3),'String'));
MA  = str2num(get(ui_handles(4),'String'));
% and check boundaries
if isempty(lb)|lb<1|lb>N
   lb=1;
   set(ui_handles(2),'String',num2str(lb));  
end;
if isempty(hb)|hb>N|hb<lb
   hb=N;
   set(ui_handles(3),'String',num2str(hb));
end;
if MA>hb-lb
   MA=1
   set(ui_handles(4),'String',num2str(MA));
end

ts= Asset(lb:hb,:);
[N M]=size(ts);

% Daily return
r=CalcRet(ts,1,Wts);

volma2=zeros(1,N-MA);
for i=1:N-MA
    volma2(i)=r(i:i+MA-1)'*r(i:i+MA-1)/MA;
end    

volma=sqrt(volma2);

h=ExpVol(ts,0.94);          % J.P. Morgan recommends 0.94

dd=1:N;

figure('NumberTitle','on','Name',' Volatility Forecasts');
subplot(2,1,1)
hold on
plot(dd(MA:N-1),volma*100,'g-')
plot(dd(2:N),sqrt(h)*100,'b--')
set(gca,'xlim',[1 N-1])
title([ticker,':   Volatility Forecasts'])
xlabel('Days')
ylabel('Volatility (%)')
legend(['MA(',num2str(MA),')'],'Exponential')
grid on

subplot(2,1,2)
hold on;
plot(r*100,'b-');
plot(dd(2:N),2*sqrt(h)*100,'c-');
plot(dd(2:N),-2*sqrt(h)*100,'c-');
legend('Daily return','2 S.D. band')
title([ticker,':   Returns and Exponential Confidence Bands'])
xlabel('Days')
ylabel('Daily return (%)');
grid on
