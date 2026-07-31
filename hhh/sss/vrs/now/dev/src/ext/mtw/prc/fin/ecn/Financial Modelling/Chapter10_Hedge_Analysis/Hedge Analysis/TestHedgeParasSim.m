% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



clear; clc;
currentpath = pwd;
File1 = 'DAXdata.xls';
File2 = 'DAXresults.xls';
File1 = [currentpath,'\',File1];
File2 = [currentpath,'\',File2];

%_________________ Input Parameter
T = 0.5;          % options time to maturity
spotPrice = 100;
k= 1:1:1000;
rate = 0.03;
d = 0;
n = 100;
m= 3;
%------------------ Pricer Selection
pricer.ID = 'Carr';   % Cosine, Carr, Lewis, Conv, BlackScholes
pricer.N = 2^12;
pricer.L = 20;
pricer.eta = 0.1;
pricer.PriceAndGreeks = PricerFactory(pricer);

%__________________ Test 1 
%------------------ Model and Data Selection NIG
model.ID = 'NIG';            % BlackScholes, NIG, Bates, Heston, VarianceGamma
model.params(1) = 3;%3.1128;
model.params(2) = -2;%-2.1093;
model.params(3) = 0.1;%0.1215;
model.PathSimulator = SimulatorFactory(model);
[valuesNIGbase,deltasNIGbase,gammasNIGbase] = pricer.PriceAndGreeks(model,spotPrice,k,T,rate,d);
stockPathNIGbase = model.PathSimulator(spotPrice,T,n,m,0.05);
model.params(1) = 3;%3.1128;
model.params(2) = -2;%-2.1093;
model.params(3) = 5;%0.1215;
model.PathSimulator = SimulatorFactory(model);
[valuesNIG1,deltasNIG1,gammasNIG1] = pricer.PriceAndGreeks(model,spotPrice,k,T,rate,d);
stockPathNIG1 = model.PathSimulator(spotPrice,T,n,m,0.05);
model.params(1) = 3;%3.1128;
model.params(2) = -2;%-2.1093;
model.params(3) = 2;%0.1215;
model.PathSimulator = SimulatorFactory(model);
[valuesNIG2,deltasNIG2,gammasNIG2] = pricer.PriceAndGreeks(model,spotPrice,k,T,rate,d);
stockPathNIG2 = model.PathSimulator(spotPrice,T,n,m,0.05);

%_____ Test 2
bsDeltaBase = blsdelta(spotPrice,k,rate,T,0.1,0);
bsDelta1 = blsdelta(spotPrice,k,rate,T,2,0);
bsDelta2 = blsdelta(spotPrice,k,rate,T,1,0);

%__________ Output
figure;plot(k,bsDeltaBase,'black');hold on;plot(k,bsDelta1,'red');hold on;plot(k,bsDelta2,'blue');hold off;
% 
figure;plot(k,deltasNIGbase,'black');hold on;plot(k,deltasNIG1,'red');hold on;plot(k,deltasNIG2,'blue');hold off;
figure;plot(k,gammasNIGbase,'black');hold on;plot(k,gammasNIG1,'red');hold on;plot(k,gammasNIG2,'blue');hold off;
figure;plot(k,valuesNIGbase,'black');hold on;plot(k,valuesNIG1,'red');hold on;plot(k,valuesNIG2,'blue');hold off;

figure;plot(stockPathNIGbase(:,1),'black');hold on;plot(stockPathNIGbase(:,2),'black');hold on;plot(stockPathNIGbase(:,3),'black');hold off;
figure;plot(stockPathNIG1(:,1),'red');hold on;plot(stockPathNIG1(:,2),'red');hold on;plot(stockPathNIG1(:,3),'red');hold off;
figure;plot(stockPathNIG2(:,1),'blue');hold on;plot(stockPathNIG2(:,2),'blue');hold on;plot(stockPathNIG2(:,3),'blue');hold off;
figure;plot(stockPathNIGbase(:,1),'black');hold on;plot(stockPathNIGbase(:,2),'black');hold on;plot(stockPathNIGbase(:,3),'black');hold on
plot(stockPathNIG2(:,1),'blue');hold on;plot(stockPathNIG2(:,2),'blue');hold on;plot(stockPathNIG2(:,3),'blue');hold off;