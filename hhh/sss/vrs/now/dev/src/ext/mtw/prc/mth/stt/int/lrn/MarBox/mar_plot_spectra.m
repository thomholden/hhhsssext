function [] = mar_plot_spectra (mar,i,j,ns)

% function [] = mar_plot_spectra (mar,i,j,ns)

disp('Spectra associated with MAR model');
[p11,f]=mar_spec(mar,i,ns);
[p22,f]=mar_spec(mar,j,ns);
[c12,f]=mar_cohere(mar,i,j,ns);


figure
subplot(2,2,1);
semilogy(f,real(p11).^2);
title('Spectrum of x');
subplot(2,2,2);
semilogy(f,real(p22).^2);
title('Spectrum of y');
subplot(2,2,4);
plot(f,real(c12));
axis([0 max(f) 0 1]);
title('Coherence');

