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



% TestCONV_L
% We consider the CONV method
% The test considers several values for L 
clear; clc;

alpha = 0;          % choose dampening parameter

S0 = 100;           % spot price of underlying
strike = 90;        % strike price

r = 0.1;            % risk-free rate
t = 0.1;            % time to maturity
q = 0;              % dividend yield
      
cp = 1;             % call(1) or put (-1)

model = 'VarianceGamma';      % name of the model
Nexp = 10;          % 2^Nexp grid points

% Selection of share price model parameters
% delta vector for different L parameter
switch model
    case 'BlackScholes'
        sigma = 0.25;   % volatility
        delta = 10:1:40;                      
        L = delta * sigma * sqrt(t);            
        pricefunc = @(x) double(FFTCONV_E(Nexp, x, alpha, cp, model, S0, t, r, q, strike, sigma));
    case 'VarianceGamma'
        sigma = 0.125; theta = -0.14; nu = 0.21;
        delta = 10:1:40;
        L = delta * sqrt(t *(sigma^2 + nu*theta^2));
        pricefunc = @(x) double(FFTCONV_E(Nexp, x, alpha, cp, model, S0, t, r, q, strike, sigma, nu, theta));
    case 'NIG'

        anig = 6.1882; bnig = -3.8941; dnig =  0.1622;
        delta = 10:1:40;
        L = delta * sqrt(t * anig^2 * dnig / ((anig^2 - bnig^2)^(3/2)));
        pricefunc = @(x) double(FFTCONV_E(Nexp, x, alpha, cp, model, S0, t, r, q, strike, anig, bnig, 1,dnig));
end

num = size(L, 2);               % get the size of L
priceEuCONV = zeros(num, 2);    % init price vector

for j = 1:size(L,2)
    priceEuCONV(j, 2) = pricefunc(L(j));            % set price
    priceEuCONV(j, 1) = L(j);                       % set L
end
plot(priceEuCONV(:,1),priceEuCONV(:,2),'-o');       % plot output
title(['Call Prices for ', model,' model and CONV method']);
legend('Call Prices for different values of L');