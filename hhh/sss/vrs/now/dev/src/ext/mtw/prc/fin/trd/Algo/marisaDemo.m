% marisa demo
load bundData
ax(1)=subplot(2,1,1);
plot([data(:,2),movavg(data(:,2),500,500,'e')]), grid on, title('minutely Bund data and EMA')
% rsi
ax(2)=subplot(2,1,2);
r=rsi2(data(:,2)-movavg(data(:,2),15*500,15*500,'e'),100);
plot(r), grid on, title('RSI on the data');
line([0 length(data(:,2))],[65 65],'color',[1 0 0],'linewidth',2);
line([0 length(data(:,2))],[35 35],'color',[1 0 0],'linewidth',2);
set(gca,'ylim',[10 90])

linkaxes(ax,'x');

figure
N=500;M=100;
[sh,pnl,pos,epnl,rpnl,epos,rpos] = marisa(data(:,2),N,M,1);