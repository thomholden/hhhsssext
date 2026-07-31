% Loads asset historical data
global Asset Wts TSFIG 

[fname, pathname] = uigetfile('*','Load Stock(s) Historical Data File');
if fname == 0
	return;
end;
load([pathname,fname]);	
ticker = strtok(fname,'.');

eval(['Asset=',ticker,';']);

M=size(Asset,2);
if M>1
   % Portfolio:
   %    load weights - if error clear Asset and return 
   [fname, pathname] = uigetfile('*','Load Assets Weights File');
   if fname == 0
      disp('Error: Incorrect weights. Use random normalized weights')
      Wts=rand(1,M);
      Wts=Wts./sum(Wts)
   else
      load([pathname,fname]);	
      wtsfname = strtok(fname,'.');
      eval(['Wts=',wtsfname,';']);
      if size(Wts,2)~=M|sum(Wts)~=1
        disp('Error: Incorrect weights: Use random normalized weights')
        Wts=rand(1,M);
        Wts=Wts./sum(Wts)
      end  
   end   
else
   Wts=0;
end

ui_handles = get(gcf,'UserData');
set(ui_handles(1),'String',ticker);
if M>1
   return
end   
lb  = str2num(get(ui_handles(2),'String'));
hb  = str2num(get(ui_handles(3),'String'));
MA  = str2num(get(ui_handles(4),'String'));

N=size(Asset,1);
% check boundaries
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

if ishandle(TSFIG)
	figure(TSFIG);
	clf;
else
	TSFIG=figure('NumberTitle','off','Name','Stock chart');
end;

dd=1:N;

[shortma,longma] = movavg(Asset,MA,MA,1);

hold on
plot(dd,Asset,'-b');
%plot(dd(1:N-MA-1),shortma,'r-');
plot(dd(MA+1:N),longma(MA+1:N),'g-');
line([lb lb],get(gca,'Ylim'),'LineStyle','-','Color','black');
line([hb hb],get(gca,'Ylim'),'LineStyle','-','Color','black');
grid on;
xlabel('Days');
ylabel('Price');
title([ticker, ' and MA(',num2str(MA),')']);
