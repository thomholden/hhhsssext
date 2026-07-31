%Tradeguide by Nagi Hatoum,Copyright March 2004
%
%Takes column-wise Close Open High and Low data
%Gives Buy and Sell signals for maximum practical profit.
%Ignores small trend changes or flat days and follow biggest local trends.Profitable spikes are included.
%Tradeguie signal offers practical trading benchmark training set for Neural Networks and other learning algorithms or TA.
%
%There are no hold signals generated.
%buy=index for buy days
%sell=index for sell days
%Tradesignal is the composite buy and sell signal vector with 1= buy and 0=sell
%Changemarker is a zero vector of the length of the time serie with 1 marking a change in trend.
function [buy,sell,tradesignal,changemarker]=tradeguide(C,O,H,L)
%%%%%%%%%%%%%%Calculate%%%%%%%%%%%%%%%%%
l=length(C);
P=mean([C,O,H,L],2);
dP=[0;diff(P)];%2 day price difference
pP=dP./P;%percent change
spP=sign(pP);%signum of day to day % change
n=find(spP==0);%%find no change days
spP(n)=sign(rand-.5);%%add small noise to no change days
spP=(spP+1)/2;%%convert to binary 0=down 1=up
%%%%filter out flat dayswith changes less than .5%
%%small noises and spikes are non-profitable neglected
for i=2:l-1
    if abs(pP(i))<.005
        spP(i)=spP(i-1);%same as prior day
    end
end
%%%%%%%%Mark signal change%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%find buy  signal%%
n=find(spP(2:end)==1);%shift back by one day 
buy=n;
%%%%%%%%find sell signal%%
n=find(spP(2:end)==0);%shift back by one day 
sell=n;
%%%%%%%%tradesignal
changemarker=xor(spP(1:end-1),spP(2:end));%finds changing signals
%%%%%%%%tradesignal
tradesignal=zeros(length(C),1);
tradesignal(buy)=1;
