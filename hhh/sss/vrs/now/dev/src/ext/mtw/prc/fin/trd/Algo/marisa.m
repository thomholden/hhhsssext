function [sh,pnl,pos,epnl,rpnl,epos,rpos] = marisa(x,N,M,doPlot)
% this is a combo model, MA+RSI
thresh=55;
S=length(x);
e=movavg(x,N,N,'e');
% take the RSI of a 'detrended' bund price
r=rsi2(x-movavg(x,15*M,15*M,'e'),M);
% we will factor in the cost of the bid/ask spread
cost=0.01;     % BUND/BOBL
%cost=0.005;    % SCHATZ
%cost=1/64;     %Treasury futures
%cost = 0.0001;  %US/EUR
%cost = 0.05;   %EUR/JPY
%cost = 0.04;   %US/JPY
%cost = 0.0005;  %AUS/USD
%cost= 0.02;
%cost=1;        % eurostoxx

rpos=zeros(S,1);
% position of the ema
epos=sign(x-e);
% position of the rsi
I= (thresh-r)<0; 
IU=[~1;I(1:end-1) & ~I(2:end)];
rpos(IU)=-1;
% crossing the lower threshold
I= ((100-thresh)-r)>0;
IL=[~1;I(1:end-1) & ~I(2:end)];
rpos(IL)=1;

for i=2:S
    if rpos(i)==0;
        rpos(i)=rpos(i-1);
    end
end

% get the total position
pos=(rpos+epos)/2; 
pos( abs(pos) < 1)=0;

% pnl calculation
epnl=epos(1:end-1).*diff(x) - abs(diff(epos))*cost/2;
rpnl=rpos(1:end-1).*diff(x) - abs(diff(rpos))*cost/2;
pnl= pos(1:end-1).*diff(x) - abs(diff(pos))*cost/2;
sh= sqrt(250)*mean(pnl)/std(pnl);
if doPlot
    plot([cumsum(pnl),pos(1:end-1)]), title(['Sharpe= ',num2str(sh)]);
end