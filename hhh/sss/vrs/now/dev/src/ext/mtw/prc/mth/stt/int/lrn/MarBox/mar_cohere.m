function [cij, f] = mar_cohere (mar,i,j,ns)

% function [cij, f] = mar_cohere (mar,i,j,ns)
% Get coherency between ith and jth time series in MAR model
% Get values from Hermitian PSD estimate (See Marple 1987; p. 387)

[pow,f]=mar_spectra(mar,ns);
cij=abs(pow(:,i,j)).^2./(pow(:,i,i).*pow(:,j,j));