% Saves results in log file
global VaR VaRhist HOLDING CI 

% Read fields
ui_handles = get(gcf,'UserData');
ticker  = get(ui_handles(1),'String');
lb  = str2num(get(ui_handles(2),'String'));
hb  = str2num(get(ui_handles(3),'String'));

logfid=fopen('Varlog','at');

if logfid == -1,
	errordlg('statlog file not found','Error','on');
else	
	fprintf(logfid,'%s %d:%d\t%g\t%g\t%d\t%0.2f', ...
		ticker,lb,hb,VaR,VaRhist,HOLDING,CI);
	fprintf(logfid,'\n');
	fclose(logfid);
end;
	
