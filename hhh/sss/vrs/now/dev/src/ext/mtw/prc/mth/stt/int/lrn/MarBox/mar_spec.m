function [p, f] = mar_spec (mar,i,ns)

% function [p, f] = mar_spec (mar,i,ns)
% Get power spectral density of ith time series in MAR model
% Get values from Hermitian PSD estimate (See Marple 1987; p. 387)
% Note: From MAR model individual spectral densities are ARMA not AR

[pow,f]=mar_spectra(mar,ns);
p=abs(pow(:,i,i)).^2;

