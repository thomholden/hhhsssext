%function btest1
%% backtesting demo

%% load in the data
data = xlsread('BundDaily.xls');

%% get try lead/lad ema's
[lead,lag]=movavg(data(:,5),5,20,'e');
% take a first look at the data
plot([data(:,5),lead,lag]), grid on

%% take a look at the positions to check the model makes sense
[pos,pnl,sh]= leadlag(data(:,5),10,50);
subplot(2,1,1), plot([data(:,5),lead,lag]), grid on
title(['First test of the model, N=10, M=50, Sh=',num2str(sh)]);
subplot(2,1,2), plot(pos), axis([0 length(pos) -5 5]), grid on
figure
plot(cumsum(pnl)), grid on
title('P&L of the first test')

%% now cycle over a range of parameters to compute a sharpe surface
N = 2:98;
SH = zeros(size(N));
for i=N
    for j=i+2:100
        [pos,pnl,sh]= leadlag(data(:,5),i,j);
        SH(i,j)=sh;
    end
end
%% take a look at some results
figure
imagesc(SH), grid on, axis square, axis tight, colorbar
title('Sharpes ratio surface')
% remove zero values from the plot
SH2=SH; SH2(SH2==0)=NaN;
%subplot(2,1,2)
figure
surf(SH2), shading interp, lighting phong, 
view([80 35]), light('pos',[0.5, -0.9, 0.05])
%% get the best sharpe's ratio
maxSH = max(max(SH));
[i,j]=find(SH==maxSH);

%% test out the best model
[pos, pnl, sh] = leadlag(data(:,5),i,j);
figure
plot(cumsum(pnl)), grid on
title(['Best model, N=',num2str(i),', M=',num2str(j),', sh=',num2str(sh)])
