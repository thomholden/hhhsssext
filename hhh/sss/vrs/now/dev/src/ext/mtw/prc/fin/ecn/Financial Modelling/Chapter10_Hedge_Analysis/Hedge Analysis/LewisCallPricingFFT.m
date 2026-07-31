% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%           Manuel Wittke
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau, Manuel Wittke
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function [call_price_fft, call_delta_fft,call_gamma_fft] = LewisCallPricingFFT(N,eta,model,S,K,T,r,d)

lnS = log(S);
lnK = log(K);

kappa = lnS-lnK;

%-------------------------
%--- FFT Option Pricing --
%-------------------------
% from: Option Valuation Using the Fast Fourier Transform, 
%       Peter Carr, March 1999, pp 10-11
%-------------------------

% predefined parameters
FFT_N = N;% must be a power of two (2^14)
FFT_eta = eta; % spacing of psi integrand

% effective upper limit for integration (18)
% uplim = FFT_N * FFT_eta;

FFT_lambda = (2 * pi) / (FFT_N * FFT_eta); %spacing for log strike output (23)
FFT_b = (FFT_N * FFT_lambda) / 2; % (20)

uvec = 1:FFT_N;
%log strike levels ranging from lnS-b to lnS+b
ku = - FFT_b + FFT_lambda * (uvec - 1); %(19)

jvec = 1:FFT_N;
vj = (jvec-1) * FFT_eta;

%applying FFT
tmp = psi(model,vj,r,d,T) .* exp(1i * vj* (FFT_b)) * FFT_eta;
tmp = (tmp / 3) .* (3 + (-1).^jvec - ((jvec - 1) == 0) ); %applying simpson's rule

% %discrete fourier transform of integrand
price_vec = real(exp(-0.5*ku).*fft(tmp))/pi;
delta_vec = real(exp(-0.5*ku).*fft((-1i*vj+0.5).*tmp))/pi; 
gamma_vec = real(exp(-0.5*ku).*fft((vj.^2+0.25).*tmp))/pi;

call_price_fft = S*(exp(-d*T)-exp(-r*T).*interp1(ku,price_vec,kappa));
call_delta_fft = (exp(-d*T) - exp(-r*T).*interp1(ku,delta_vec,kappa));
call_gamma_fft = exp(-r*T)/S.*interp1(ku,gamma_vec,kappa);

end




%analytical formula for zhi in equation ( 6 ) of Madan's paper
function ret = psi(model,v,r,d,T)
  ret = exp(feval(@CharacteristicFunctionLib, model, -v - 0.5 * 1i,T,r,d,model.params)) ./ (v.^2 + 0.25);
end