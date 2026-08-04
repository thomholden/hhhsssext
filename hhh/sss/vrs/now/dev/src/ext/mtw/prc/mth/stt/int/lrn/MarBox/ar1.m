function [] = ar1 (a1,dev)

% function [] = ar1 (a1,dev)
% Generate data from AR(1) model
% a1   AR coefficient
% dev  noise variance

T=100;
x(1)=0.01;
for i=2:T,
  x(i) = a1*x(i-1);
  x(i) = x(i) + dev*randn(1,1);
end

figure
subplot(3,1,1);
plot(x);
title('Time series');

c=xcorr(x,'coeff');
subplot(3,1,2);
plot(c);
title('Autocorrelation function');

[Pxx,f,a] = pburg(x,8,[],T);
subplot(3,1,3);
plot(f,Pxx);
title('AR spectrum calcualte from time series - not coeff');