%Wilson Palmeiro@Copyright. This exercise has got real data. Because we
%want to test in market. Finally we test for 500 days. WE can assume any
%finantial asset.
dy=price2ret(Open,[],'continuous');%Differenciate data
N=length(dy);
[PartialACF, lags, bounds]=parcorr(dy,[],[],2);%Analyze PACF
[ACF, lags, bounds]=autocorr(dy,[],[],1.96);%Analyze ACF in order to choose the order of model
figure()
subplot(2,2,1)
plot(dy)
subplot(2,2,2)
autocorr(dy)
subplot(2,2,3)
parcorr(dy)
subplot(2,2,4)
plot(Open);
[h,p,Qstat, crit]=lbqtest(dy,'lags', [5,10,15,21,30,36]);
model=arima(1,1,1)%At this time we will use the mean level
fit=estimate(model,dy)%to predict.
[Y, YMSE]=forecast(fit,500,'Y0',dy)%It´s more commom in market using
Price=ret2price(Y,[1833.32000000000],1,[],'Periodic')%At this level i put one of prices
Lower=Y-1.96*sqrt(YMSE);%GARCH  to predict volatility.
Upper=Y+1.96*sqrt(YMSE);
figure(2)
plot(dy,'Color',[.7,.7,.7]);
hold on
h1=plot(N+500:N+500,Lower,'r','LineWidth',2);
plot(N+500:N+500,Upper,'r','LineWidth',2);
h2=plot(N+500:N+500,Y,'k','LineWidth',2);
legend([h1 h2], '95% Interval', 'Forecast','Location','NorthWest')
title('Forecast Using ARMA Model')
hold off