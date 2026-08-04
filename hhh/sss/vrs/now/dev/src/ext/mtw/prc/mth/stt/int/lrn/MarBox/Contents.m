% MARBOX, version 1.1, William Penny, July 1998
% A matlab toolbox for multivariate autoregressive (MAR) models
%
% MAR MODELS
%
% mar_learn          get MAR model from multiple time series
% mar_gen            generate mutiple time series from MAR model
% mar_cov            get cross-covariance matrix for MAR model
% rmar               running MAR models in overlapping windows
%
% DATA GENERATION
%
% coherent            generate coherent sine waves
% incoherent          generate incoherent sine waves
%
% SPECTRAL ESTIMATION
%
% ar_spec             get spectrum from AR coeffs using th2ff
% ar_spectra          get spectrum from AR coeffs directly
% freq_ar2            get spectrum for AR(2)from polynomial
% mar_spectra         calculate Hermitian PSD matrix from MAR model
% mar_cohere          get coherence between channels from MAR model
% mar_spec            get individual spectral densities from MAR model
% mar_cohere_compare  compare coherences for two MAR models
% mar_plot_spectra    plot MAR spectra
%
%                     These routines have been replaced by the ones above:
%                     (they were replaced because  coherence > 1 !)
% mar_cov_spec        Do FFT of covariance matrices to get spectral density
% mar_cov_cohere      Do FFT of covariance matrices to get coherence
% mar_cov_allspec     Do FFT of covariance matrices to get all coherences
%
% plot_cohere         plot coherencies of time series (not using AR/MAR)
%
% EXAMPLES
%
% ar1                 generate data from AR(1) model
% ar2                 generate data from AR(2) model
% demmar1             Get known spectra from known MAR coeffs
% demmar2             Gen coherent or incoherent series and get MAR coeffs

