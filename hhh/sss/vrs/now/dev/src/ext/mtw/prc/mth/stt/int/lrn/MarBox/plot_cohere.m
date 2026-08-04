function [] = plot_cohere(x,y,t,ns)

% function [] = plot_cohere(x,y,t,ns)
% Given two time series, x and y, given at time samples t
% Plot coherency and associated functions

figure
subplot(2,2,1);
plot(t,x);
hold on
plot(t,y+5);
title('Times Series; X, Y+5');

subplot(2,2,2);
[cxy,f]=cohere(x,y,128,128);
plot(f,cxy); 
title('Coherency of XY');

subplot(2,2,3);
[pxx,f]=psd(x,ns,ns);
plot(f,pxx); 
title('Spectrum of X');

subplot(2,2,4);
[pyy,f]=psd(y,ns,ns);
plot(f,pyy); 
title('Spectrum of Y');



return

figure
subplot(3,1,1);
plot(t,x);
hold on
plot(t,y+5);
title('Original data');

%subplot(3,1,2);
%[c]=run_corr([x(:),y(:)],2*ns,0.2*ns);
%size(c)
%plot(c); 
%title('Running correlation');

subplot(3,1,3);
[cxy,f]=cohere(x,y,128,128);
plot(f,cxy); 
title('Coherency');

figure
subplot(3,2,1);
[pxx,f]=psd(x,ns,ns);
plot(f,pxx); 
title('Spectrum');

subplot(3,2,2);
[pyy,f]=psd(y,ns,ns);
plot(f,pyy); 
title('Spectrum');

[pxy,f]=csd(x,y,ns,ns);

subplot(3,2,3);
plot(f,real(pxy));
title('Co-spectrum');

subplot(3,2,4);
plot(f,imag(pxy));
title('Quadrature spectrum');

subplot(3,2,5);
plot(f,abs(pxy)); 
title('Cross spectrum');

subplot(3,2,6);
cxy2=(abs(pxy).^2)./(pxx.*pyy);
plot(f,cxy2);
title('Coherency');


