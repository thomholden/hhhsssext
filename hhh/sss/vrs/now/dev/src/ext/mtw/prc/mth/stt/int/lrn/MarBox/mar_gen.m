function [Y] = mar_gen (mar, T, e)

% function [Y] = mar_gen (mar, T, e)
% Generate T samples of time series from MAR model
% mar.lag(k).a   is ar coefficient matrix at lag k
% mar.noise_cov  estimated noise covariance
% T              number of samples to generate
% e              (optional) error vector
% Y              T-by-d matrix containing d-variate time series

use_e_vector=0;
if (nargin==3)
  use_e_vector=1;
  disp('Hi');
end

p=mar.p;  % Order of AR model
d=size(mar.lag(1).a,1);
Y=zeros(d,T);

% Generate first p elements
for i=1:p,
  if use_e_vector
    Y(:,i)=e(:,i);
  else
     Y(:,i)=gaussian(1,zeros(1,d),mar.noise_cov)';
  end
end 

% Generate rest of series
for i=p+1:T,
  for k=1:p,
    Y(:,i)=Y(:,i)-mar.lag(k).a*Y(:,i-k);
  end
  if use_e_vector
    Y(:,i)=Y(:,i)+e(:,i);
  else
    Y(:,i)=Y(:,i)+gaussian(1,[0,0],mar.noise_cov)';
  end
end

