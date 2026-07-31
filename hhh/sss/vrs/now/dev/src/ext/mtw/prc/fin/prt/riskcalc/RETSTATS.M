% Draw distribution statistics
global Asset Wts
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
MA  = str2num(get(ui_handles(4),'String'));
% and check boundaries
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

ts= Asset(lb:hb,:);

[N M]=size(ts);

% Daily return
r=CalcRet(ts,1,Wts);

% Return distribution momenta
trend=mean(r);
vol=std(r);
skew=skewness(r);
kurt=kurtosis(r);

figure('NumberTitle','on','Name',[ticker,' Return Distribution Statistics']);
xlabel('Return'), ylabel('% of Total')
hold on;

[Ndr X]= hist(r,50);
bar(X,Ndr/sum(Ndr),1,'c');

unity=0;
dx=X(2)-X(1);
for i=1:size(X,2)
   unity=unity+Ndr(i)*dx;
end 
unity=unity/sum(Ndr);

% Approximation of return distribution by normal
[mu,sigma,muci,sigci]=normfit(r,0.005);   % 99.5% confidence 

xx=1.25*min(X):0.001:1.25*max(X);
%bell=normpdf(xx,mu,sigma);

bell = exp(-0.5*((xx-mu)/sigma).^2) / (sqrt(2*pi)* sigma);

plot(xx,bell*unity,'b-');

title([ticker,'   Mean =',num2str(trend*100),...
   '%  St. dev = ', num2str(vol*100),...
   '%  Skewness =',num2str(skew), ...
   '  Kurtosis =',num2str(kurt)]);
