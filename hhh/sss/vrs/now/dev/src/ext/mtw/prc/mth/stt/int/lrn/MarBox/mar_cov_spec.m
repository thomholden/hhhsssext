function [pij, f] = mar_cov_spec (mar,i,ns)

% function [pij, f] = mar_cov_spec (mar,i,j, ns)
% Get spectral power density associated ith time series in MAR model
% by first evaluating covariance function and then doing FFT
% mar.lag(k).a     is ar coefficient matrix at lag k
% mar.noise_cov    estimated noise deviation
% mar.lag(k).gamma covariance matrix at lag k              

p=mar.p;  % Order of AR model
d=size(mar.lag(1).a,1);

% Get covariance matrices if not there already
if ~isfield(mar.lag(1),'gamma') 
  disp('Calculating covariances first');
  mar=mar_cov(mar);
end

% Isolate appropriate (cross)-covariance matrix
for k=1:mar.cov_nlags,
   cross_cov(k,:)=mar.lag(k).gamma(i,i);
end


% Remember - the spectrum of a real signal is real but the
% cross spectrum of two real signals is complex. This
% is because the cross-covariance is not an even function
[pij]=fft(cross_cov,mar.cov_nlags);

select=[1:mar.cov_nlags/2+1];
f=(select-1)'*ns/mar.cov_nlags;
pij=abs(pij(select)).^2;

show=1;
if show==1
  figure
  plot(f,abs(pij));
end