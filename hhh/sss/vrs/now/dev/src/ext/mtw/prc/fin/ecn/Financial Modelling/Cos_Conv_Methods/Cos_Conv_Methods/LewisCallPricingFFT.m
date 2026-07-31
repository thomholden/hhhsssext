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
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 



function call_price_fft = LewisCallPricingFFT(model,n,S,K,T,r,d,varargin)

lnS = log(S);
lnK = log(K);

kappa = lnS-lnK;
%kappa = lnK;
%-------------------------
%--- FFT Option Pricing --
%-------------------------
% from: Option Valuation Using the Fast Fourier Transform, 
%       Peter Carr, March 1999, pp 10-11
%-------------------------

% predefined parameters
FFT_N = 2^n;% must be a power of two (2^14)
FFT_eta = .1;%0.25; % spacing of psi integrand

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
tmp = exp(-1i*(- vj - 0.5 * 1i)*lnS*T).*psi(model,vj,lnS,T,r,d,varargin{:}) .* exp(1i * vj * (FFT_b)) * FFT_eta;
%tmp = psi(model,vj,lnS,T,r,d,varargin{:}) .* exp(1i * vj * (FFT_b)) * FFT_eta;

tmp = (tmp / 3) .* (3 + (-1).^jvec - ((jvec - 1) == 0) ); %applying simpson's rule
integralvec = fft(tmp); %call price vector resulting in equation 24

indexOfInterest = floor((kappa+ FFT_b)/FFT_lambda + 1); 

minoi = min(indexOfInterest);
maxoi = max(indexOfInterest);
iset = maxoi+1:-1:minoi-1;
xp = ku(iset);
yp = integralvec(iset);

call_price_fft = S*exp(-d*T)-sqrt(S*K).*exp(-r*T).*real(interp1(xp,yp,kappa))/pi;


end




%analytical formula for zhi in equation ( 6 ) of Madan's paper
function ret = psi(model,v,varargin)
  ret = exp(feval(@CharacteristicFunctionLib, model, - v - 0.5 * 1i,varargin{:})) ./ (v.^2 + 0.25);
end