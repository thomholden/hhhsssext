function [pow,f] = mar_spectra (mar,ns);

% function [pow,f] = mar_spectra (mar,ns);
% Get Hermitian PSD from MAR coefficients
% See Marple (1987; page 408)
% mar.lag(k).a     is ar coefficient matrix at lag k
% mar.noise_cov    estimated noise deviation
% ns    samples per second

p=mar.p;
d=size(mar.lag(1).a,1);

ff=0;
for w=pi/128:pi/128:pi,
  ff=ff+1;
  af_tmp=eye(d);
  for k=1:p,
    af_tmp=af_tmp+mar.lag(k).a*exp(-i*w*k);
  end
  iaf_tmp=inv(af_tmp);
  pow(ff,:,:) = iaf_tmp * mar.noise_cov * iaf_tmp';
end

f=[0.5*ns/128:0.5*ns/128:0.5*ns]';

  
