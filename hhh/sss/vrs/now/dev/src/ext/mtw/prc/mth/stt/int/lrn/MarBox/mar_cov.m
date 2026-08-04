function [mar] = mar_cov (mar)

% function [mar] = mar_cov (mar)
% Generate auto and cross-covariance matrices associated with MAR model
% mar.lag(k).a     is ar coefficient matrix at lag k
% mar.noise_cov    estimated noise deviation
% mar.lag(k).gamma covariance matrix at lag k              

p=mar.p;  % Order of AR model
d=size(mar.lag(1).a,1);
mar.cov_nlags=128;

% Get covariance matrices from Matrix Yule-Walker relations
% Get first p cov matrices
mar.lag(1).gamma =  mar.noise_cov; % Cov matrix at lag 0 = Cov matrix of noise

for k=2:p+1,
  mar.lag(k).gamma=zeros(d,d);
  for i=1:k-1,
    mar.lag(k).gamma=mar.lag(k).gamma + mar.lag(i).a*mar.lag(k-i).gamma;
  end
end
% Get rest of cov matrices
for k=p+2:mar.cov_nlags,
  mar.lag(k).gamma=zeros(d,d);
  for i=1:p,
    mar.lag(k).gamma=mar.lag(k).gamma + mar.lag(i).a*mar.lag(k-i).gamma;
  end    
end


