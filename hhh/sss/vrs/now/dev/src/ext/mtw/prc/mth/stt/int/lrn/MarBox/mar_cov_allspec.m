function [mar] = mar_cov_allspec (mar)

% function [mar] = mar_cov_allspec (mar)
% Plot all spectra and cross-spectra associated with MAR model
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

% get and plot spectra
for i=1:d,
  for k=1:mar.cov_nlags,
    c(k,i)=mar.lag(k).gamma(i,i);
  end  
end
figure
for i=1:d,
  [pxx(:,i),f]=psd(c(:,i),mar.cov_nlags,mar.cov_nlags);
  subplot(d,1,i);
  plot(f,pxx(:,i));
end


% get cross-spectra
nc=0;
for i=1:d,
  for j=i+1:d,
    nc=nc+1;
    [i,j]
    for k=1:mar.cov_nlags,
      cross_cov(k,nc)=mar.lag(k).gamma(i,j);
    end
  end
end
figure
for i=1:nc,
  [pxx,f]=psd(cross_cov(:,i),mar.cov_nlags,mar.cov_nlags);
  subplot(nc,1,i);
  plot(f,pxx);
end
