function [] = ar2 (a1,a2,dev)

% function [] = ar2 (a1,a2,dev)
% Generate data from AR(2) model
% a1,a2   AR coefficients (make sure signs of coeffs are correct)
% dev     noise variance
% Example usage: ar2(1.5,-0.9,0) gives 10Hz decay

% Stationarity test - see Chatfield, page 39

r1=(a1+sqrt(a1^2+4*a2))/2;
r2=(a1-sqrt(a1^2+4*a2))/2;

if (abs(r1) < 1 & abs(r2) < 1)
  disp('AR process is stationary');
else
  disp('AR process is non-stationary');
end


T=100;
x(1)=0.01;
x(2)=0.01;
for i=3:T,
  x(i) = a1*x(i-1) + a2*x(i-2);
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

[p,f]=freq_ar2(a1,a2,T);
subplot(3,1,3);
plot(f,p);
disp('AR spectrum');