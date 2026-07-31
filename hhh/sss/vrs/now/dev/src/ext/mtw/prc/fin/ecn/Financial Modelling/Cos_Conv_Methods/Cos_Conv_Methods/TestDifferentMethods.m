
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



% TestMethodsi
% Pricing American options using COS, CONV, Lewis or Carr-Madan method
% Calculate price and measure speed and deviation from reference value
%    for a European option for changing the number of grid points
% Model : Variance Gamma model
% Method: COS, CONV, Lewis, Carr-Madan

clear; clc;
n = (10:16)';               % N = 2^n grid points
num = size(n, 1);

S0 = 100;                   % spot price of underlying
strike = 120.5;             % strike price

r = 0.1;                    % risk-free rate
t = 1;                      % time to maturity
q = 0;                      % dividend yield

cp = 1;                     % call (1) put (-1)

parity = 0;                 % use put-call parity (1) or not (0)

% The Variance Gamma model
type = 'VarianceGamma';
sigma = 0.12;                % volatility of the share, per sqrt(unit) time
theta = -0.14;
nu = 0.2;
mu = (r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));

% COS method
% Lcos = 10;     
% 
% c1 = (mu + theta) * t;
% c2 = (sigma^2 + nu * theta^2) * t;
% c4 = 3 * (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * t;
% c = [c1, c2, c4];
% pricefunccos = @(x) double(FFTCOS_E(x, Lcos, c, cp, type, S0, t, r, q, strike, sigma, nu, theta));
%        

% CONV method
% delta = 40;
% Lconv = delta * sqrt(t *(sigma^2 + nu*theta^2));
% pricefuncconv = @(x) double(FFTCONV_E(x, Lconv, 0.5, cp, type, S0, t, r, q, strike, sigma, nu, theta));

% Lewis
% pricefunclewis = @(x) double(LewisCallPricingFFT('VarianceGamma',x,S0,strike,t,r,q,sigma,nu,theta));

% Carr-Madan

refval = CallPricingFFT('VarianceGamma',20,S0,strike,t,r,q,sigma,nu,theta);
imethodvalue = ones(1,6); imethodvalue = cumsum(imethodvalue);
result_p = zeros(1, size(imethodvalue,2));

% selecting different interpolation methods
for k = 1:size(imethodvalue,2)
      switch imethodvalue(k)
        case 1
            imethod = 'nearest';
        case 2
            imethod = 'linear';
        case 3
            imethod = 'spline';
        case 4
            imethod = 'pchip';
        case 5
            imethod = 'cubic';
        otherwise
            imethod = 'v5cubic';
      end
%     res = 0;
%     res_t = cputime;
%     for l = 1:NAverage
%         res = pricefunccos(n(k));
%     end
%     result_t(1,k) = (cputime - res_t) / NAverage * 1000;
%     result_p(1,k) = (refval - res)/refval*10000;
%     
%     res = 0;
%     res_t = cputime;
%     for l = 1:NAverage
%         res = pricefuncconv(n(k));
%     end
%     result_t(2,k) = (cputime - res_t) / NAverage * 1000;
%     result_p(2,k) = (refval - res)/refval*10000;
%     res = 0;
%     res_t = cputime;
%     for l = 1:NAverage
%         res = pricefunclewis(n(k));
%     end
%     result_t(3,k) = (cputime - res_t) / NAverage * 1000;
%     result_p(3,k) = (refval - res)/refval*10000;
    res = 0;
%    for l = 1:NAverage
        res = CallPricingFFTi('VarianceGamma',14,S0,strike,t,r,q,imethod,sigma,nu,theta);

%    end
    result_p(k) = (refval - res)/refval*10000;
end

