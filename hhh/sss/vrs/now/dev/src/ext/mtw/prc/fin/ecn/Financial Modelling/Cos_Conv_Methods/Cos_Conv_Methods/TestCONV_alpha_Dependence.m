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



% TestCONV_alpha
% We consider the CONV method
% The test considers several values for alpha (dampening)
clear; clc;

alpha = -5:0.25:5;          % choose dampening parameter
num = size(alpha, 2);       % get the size of alpha array
priceEuCONV = zeros(num, 2);% init the price vector    
S0 = 100;                   % price of underlying
strike = 90;                % strike price

r = 0.1;        % risk-free rate
t = 0.1;        % time to maturity
q = 0;          % dividend yield
      
cp = 1;         % call (1); put (-1)

model = 'VarianceGamma';    % choice of asset price model
            
Nexp = 10;                  % 2^Nexp grid points
% Selection of share price model parameters
% delta parameter for CONV and L using rule of thumb
switch model
    case 'BlackScholes'
        sigma = 0.25;                   % volatility
        delta = 20;                     
        L = delta * sigma * sqrt(t);                
        pricefunc = @(x) double(FFTCONV_E(Nexp, L, x, cp, model, S0, t, r, q, strike, sigma));
    case 'VarianceGamma'
        sigma = 0.12; theta = -0.14; nu = 0.2; % model parameter
        delta = 40;                            
        L = delta * sqrt(t *(sigma^2 + nu*theta^2)); 
        pricefunc = @(x) double(FFTCONV_E(Nexp, L, x, cp, model, S0, t, r, q, strike, sigma, nu, theta));
    case 'NIG'
        anig = 6.1882; bnig = -3.8941; dnig =  0.1622; 
        delta = 40;                            
        L = delta * sqrt(t * anig^2 * dnig / ((anig^2 - bnig^2)^(3/2)));
        pricefunc = @(x) double(FFTCONV_E(Nexp, L, x, cp, model, S0, t, r, q, strike, anig, bnig, 1,dnig));
end

for j = 1:size(alpha,2)
    priceEuCONV(j, 2) = pricefunc(alpha(j));    % set the value
    priceEuCONV(j, 1) = alpha(j);               % set the alpha used
end
plot(priceEuCONV(:,1),priceEuCONV(:,2),'-o');   % plot results
title(['Call Prices for ', model, ' model and CONV method']);
legend('Call Prices for different \alpha');