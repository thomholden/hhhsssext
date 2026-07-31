global Asset Wts VaR VaRhist HOLDING CI 
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
HOLDING  = str2num(get(ui_handles(5),'String'));
CI    = str2num(get(ui_handles(6),'String'));

% and check boundaries
if isempty(lb)|lb<1|lb>N
   lb=1;
   set(ui_handles(2),'String',num2str(lb));  
end;
if isempty(hb)|hb>N|hb<lb
   hb=N;
   set(ui_handles(3),'String',num2str(hb));
end;

ts= Asset(lb:hb,:);

[VaR, VaRhist] = VaRisk(ticker,ts,HOLDING,CI,Wts);
