function [mar] = mar_learn (X,p)

% function [mar] = mar_learn (X,p)
% Multivariate AutoRegression (MAR) 
% Matrix of AR coefficients are in form
% y_t = -a_1 y_t-1 + -a_2 y_t-2 + ...... + -a_p y_t-p
% where a_k is d-by-d matrix of coefficients at lag k and y_t-k's are 
% vector of multivariate time series
% X              T-by-d matrix containing d-variate time series
% p              order of AR model
% mar.lag(k).a   is ar coefficient matrix at lag k
% mar.noise_cov  estimated noise covariance

d=size(X,2);    % dimension of time series
N=size(X,1);    % length of time series
th=arx(X,p*ones(d,d));  % Use Matlab ARX routine

tha=th2par(th);
tmpa=reshape(tha,p*d,d);

e=pe(X,th);     % prediction error of model
mar.noise_cov=(e'*e)/(N-p*d*d);

for k=1:p,
  start=(k-1)*d+1;
  stop=(k-1)*d+1+(d-1);
  % THIS NEGATIVE SIGN IS V. IMPORTANT - without this
  % mar_spectra will all be incorrect
  % It is necessary as whoever implemented ARX did it
  % for y_t = a_1 y_t-1 + a_2 y_t-2 etc.
  % despite Ljung's (p.71) and Marple's etc definition
  mar.lag(k).a=-1*tmpa(start:stop,:)';
end

mar.p=p;

