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



% This is a shell to initiate the pricing of European options via COS
    % (This outputs an (n* x 4) matrix, where column 1 contains the number of grid points, N = 2^n,
    % column 2 contains the option price approximation, column 3 contains the deviation from the 
    % option price 'benchmark,' and column four contains the average CPU runtime.)
    % n* is the number of elements in n (see below).


n = 6;    % choose number of grid points (applied to Bermudan only), N = 2^n

S0 = 100;           % price of underlying
strike = 100;       % strike price
r = 0.1;          % annual risk-free rate (cc)
t = 5;         % term to maturity
q = 0;              % annual dividend yield (cc)

cp = 1;            % choice of call (=1) or put (=-1)


type = 'BlackScholes';       % choice of asset price model


% Selection of share price model parameters
switch type
    
    case 'BlackScholes'
        sigma = 0.25;                % volatility of the share, per sqrt(unit) time
        
        L = 1:1:100;
        
        mu = (r - q - 0.5 * sigma^2) * t;
        
        c1 = double(mu);
        c2 = double(sigma^2 * t);
        c4 = 0;
        c = [c1, c2, c4];
        pricefunc = @(x) double(FFTCOS_E(n, x, c, cp, type, S0, t, r, q, strike, sigma));
        
    case 'VarianceGamma'
        sigma = 0.18;                % volatility of the share, per sqrt(unit) time
        theta = -0.13;
        nu = 0.25;
        
        L = 1:1:100;
        
        mu = (r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));
        
        c1 = (mu + theta) * t;
        c2 = (sigma^2 + nu * theta^2) * t;
        c4 = 3 * (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * t;
        c = [c1, c2, c4];
        pricefunc = @(x) double(FFTCOS_E(n, x, c, cp, type, S0, t, r, q, strike, sigma, nu, theta));
    case 'NIG'
        alphaNIG = 24.14154;
        betaNIG = -17.6234;
        deltaNIG =  0.635434;
        
%         alphaNIG = 6.1882;
%         betaNIG = -3.8941;
%         deltaNIG =  0.1622;
        
        L = 1:1:100;
        
        mu = r - q;
        
        c1 = ((betaNIG*deltaNIG)/(sqrt(alphaNIG^2 - betaNIG^2)) + mu) * t;
        c2 = t * alphaNIG^2 * deltaNIG / ((alphaNIG^2 - betaNIG^2)^(3/2));
        c4 = 3 * t * alphaNIG^2 * (alphaNIG^2 + 4*betaNIG^2) * deltaNIG / ((alphaNIG^2 - betaNIG^2)^(7/2));
        c = [c1, c2, c4];
        
        pricefunc = @(x) double(FFTCOS_E(n, x, c, cp, type, S0, t, r, q, strike, alphaNIG, betaNIG, 1, deltaNIG));
end

num = size(L, 2);
priceEuCOS = zeros(num, 2);


for j = 1:size(L,2)
   priceEuCOS(j, 2) = pricefunc(L(j));
   priceEuCOS(j, 1) = L(j);
end

plot(priceEuCOS(:,1),priceEuCOS(:,2),'-o');
title(['Call Prices for ', type,' model and COS method']);
legend('Call Prices for different values of L');
clear; clc;
