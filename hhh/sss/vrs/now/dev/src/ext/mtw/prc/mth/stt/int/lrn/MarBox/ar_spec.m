function [p,f] = ar_spec (a,var,ns);

% function [p,f] = ar_spec (a,var,ns);
% Get spectrum from AR coefficients 
% a     vector of AR coefficients
% var   variance of noise term
% ns    samples per second

a=a(:)';
a=[1,a];
b=[];
c=1;
d=1;
f=[];
lam=var;     
t=1;

th=poly2th(a,b,c,d,f,lam,t);

specinfo=th2ff(th);
nrows=size(specinfo,1);
p=specinfo(2:nrows,2);          % the actual spectrum
f=[0.5*ns/128:0.5*ns/128:0.5*ns]';

show=0;
if show==1
  figure
  plot(f,p);
end
  

% To get the spectral error bars we need to input more info into the
% theta matrix - then do :
% e=specinfo(2:nrows,3);          % the spectral error bars
