function [VaRpar, VaRhist]=VaRisk(name,ts,T,ci,wts)
% Value at Risk calculation using parametric approach and historical simulation
% Input:
%   name - asset name
%   ts - asset(s) price time series
%   T - holding period 
%   ci - confidence interval (0.95 by default)
%   wts - weights of assets in portfolio (for portfolio VaR only)
% Output:
%   VaRpar - J.P. Morgan RiskMetrics VaR
%   VaRhist - historical simulation VaR
% (c) by A.Ivanov

if ci<0|ci>1
   error('Error: CI must be stritly between 0 and 1')
end   

if T<1
   error('Error: Holding period must be positive')   
end

T=fix(T);

[N M]=size(ts);

r=CalcRet(ts,T,wts);

[Np X]=hist(r,50);

figure('NumberTitle','on','Name',[name,' Return Distribution and VaR']);
xlabel('Return'), ylabel('% of Total')
hold on;
bar(X,Np./sum(Np),1,'c')

vol=std(r);
% Parametric VaR
VaRparpc = norminv(ci) * vol;
VaRpar = VaRparpc * ts(N,1);
% Historical simulation VaR
if min(X)< 0
   sumNp=0;
   Ntot=sum(Np);
   i=1;
   while sumNp < (1-ci)*Ntot
      sumNp = sumNp + Np(i);
      i=i+1;
   end
   if X(i-1) < 0
      VaRhist=-X(i-1)*ts(N,1);
      line([X(i-1) X(i-1)],[0 max(Np)/Ntot],'LineStyle','-','Color','red');
   else
      VaRhist=0;
   end   
else
   VaRhist=0;
end   

VaRhistpc=VaRhist/ts(N,1);

title([name,'   Parametric VaR = ',num2str(VaRpar),...
      '(',num2str(VaRparpc*100),'%) Historical simulation VaR = ',...
   num2str(VaRhist),...
   '(',num2str(VaRhistpc*100),'%)  (CI=',num2str(ci), ...
   ',T=',num2str(T),')']);
