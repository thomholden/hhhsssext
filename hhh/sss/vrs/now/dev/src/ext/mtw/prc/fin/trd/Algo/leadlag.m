function [pos, pnl, sh] = leadlag(x,N,M)
% function to work out position, pnl and sharpe's ratio
% for a simple lead/lag ema model.
% The function takes in:
% x - *price* data
% N - short window (lead)
% M - long window (lag)

pos=zeros(size(x,1),1);
[lead,lag]= movavg(x,N,M,'e');
pos(lead>lag)=1;    pos(lag>lead)=-1;
pnl = [0;pos(1:end-1).*diff(x)];
sh = sqrt(250)*mean(pnl)/std(pnl);