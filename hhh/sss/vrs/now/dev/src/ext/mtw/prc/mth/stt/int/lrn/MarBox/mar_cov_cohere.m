function [cij, f] = mar_cov_cohere (mar,i,j,ns)

% function [cij, f] = mar_cov_cohere (mar,i,j,ns)
% Get coherency between ith and jth time series in MAR model
% by first calculating covariance function then doing FFT
% mar.lag(k).a     is ar coefficient matrix at lag k
% mar.noise_cov    estimated noise deviation
% mar.lag(k).gamma covariance matrix at lag k              
% Algorithm is based on cohere.m in sig proc toolbox
% PROBLEM: coherence values are not guaranteed to be between 0 and 1

p=mar.p;  % Order of AR model
d=size(mar.lag(1).a,1);

% Get covariance matrices if not there already
if ~isfield(mar.lag(1),'gamma') 
  disp('Calculating covariances first');
  mar=mar_cov(mar);
end

window=ones(mar.cov_nlags,1);
% Isolate appropriate (cross)-covariance matrix
for k=1:mar.cov_nlags,
   cross_cov_x(k,:)=mar.lag(k).gamma(i,i);
end
xx=fft(window.*cross_cov_x,mar.cov_nlags);

% Isolate appropriate (cross)-covariance matrix
for k=1:mar.cov_nlags,
   cross_cov_y(k,:)=mar.lag(k).gamma(j,j);
end
yy=fft(window.*cross_cov_y,mar.cov_nlags);

% Isolate appropriate (cross)-covariance matrix
for k=1:mar.cov_nlags,
   cross_cov_xy(k,:)=mar.lag(k).gamma(i,j);
end
xy=fft(window.*cross_cov_xy,mar.cov_nlags);

%cross_corr=cross_cov_xy./(cross_cov_x.*cross_cov_y);
%plot(cross_corr);
%figure
%plot(cross_cov_xy);

xx=abs(xx);
yy=abs(yy);
xy2=abs(xy).^2;

% Remember - the spectrum of a real signal is real but the
% cross spectrum of two real signals is complex. This
% is because the cross-covariance is not an even function

select=[1:mar.cov_nlags/2+1];
f=(select-1)'*ns/mar.cov_nlags;
sxx=xx(select);
syy=yy(select);
sxy=xy2(select);

cij=(sxy)./(sxx.*syy);

return

figure
subplot(2,2,1);
plot(f,sxx);
sum(xx)
subplot(2,2,2);
plot(f,syy);
sum(yy)
subplot(2,2,3);
plot(f,sxy);
sum(sxy)
subplot(2,2,4);
plot(f,cij);