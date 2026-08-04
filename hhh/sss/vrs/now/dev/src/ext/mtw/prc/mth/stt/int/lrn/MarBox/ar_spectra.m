function [pow,f] = ar_spectra (a,var,ns);

% function [pow,f] = ar_spectra (a,var,ns);
% Get spectrum from AR coefficients - don't use th2ff
% a     vector of AR coefficients
% var   variance of noise term
% ns    samples per second

a=a(:)';
p=length(a);

ff=0;
for w=pi/128:pi/128:pi,
  ff=ff+1;
  denom=0;
  for k=1:p,
    denom=denom+a(k)*exp(-i*w*k);
    %exp(-i*2*pi*f*k*ns)
  end
  denom=denom+1;
  pow(ff)=1/(abs(denom)^2);
end

pow=pow*var;
f=[0.5*ns/128:0.5*ns/128:0.5*ns]';

show=1;
if show==1
  figure
  plot(f,pow);
end
  
