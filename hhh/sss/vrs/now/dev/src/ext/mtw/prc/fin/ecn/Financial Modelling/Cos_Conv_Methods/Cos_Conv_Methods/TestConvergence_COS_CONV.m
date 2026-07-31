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



% TestConvergence_Cos_CONV

n = (6:14)';                % 2^n grid points
num = size(n, 1);           % size of n array
price = zeros(num, 3);      % price array

price(:, 1) = n;            % 

alpha_d = 0;                % dampening parameter for conv

S0 = 100;                   % spot price of underlying
strike = 90;                % strike price

r = 0.1;                    % risk-free rate
t = 0.1;                    % time to maturity
q = 0;                      % dividend yield
      
cp = 1;                     % call (1); put (-1)

model = 'NIG';              % name of model

% Set delta, L for CONV and mu and c for COS
switch model
    case 'BlackScholes'
        sigma = 0.25; 
        delta = 20;
        L = max(10,delta * sigma * sqrt(t));

        mu = (r - q - 0.5 * sigma^2) * t;  
        
        c1 = double(mu);                      % cumulant c1
        c2 = double(sigma^2 * t);             % cumulant c2
        c4 = 0;                               % cumulant c4  
        c = [c1, c2, c4];                     % cumulant vector
        % pricing functions for CONV and COS
        pricefunc_conv = @(x) double(FFTCONV_E(x, L, alpha_d, cp, model, S0, t, r, q, strike, sigma));
        pricefunc_cos = @(x) double(FFTCOS_E(x, L, c, cp, model, S0, t, r, q, strike, sigma));
    case 'VarianceGamma'
        sigma = 0.12; theta = -0.14; nu = 0.2;
        delta = 40;
        L = max(10,delta * sqrt(t *(sigma^2 + nu*theta^2)));
        
        mu = (r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));
        
        c1 = (mu + theta) * t;
        c2 = (sigma^2 + nu * theta^2) * t;
        c4 = 3 * (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * t;
        c = [c1, c2, c4];
        % pricing functions
        pricefunc_conv = @(x) double(FFTCONV_E(x, L, alpha_d, cp, model, S0, t, r, q, strike, sigma, nu, theta));
        pricefunc_cos =@(x) double(FFTCOS_E(x, L, c, cp, model, S0, t, r, q, strike, sigma, nu, theta));
    case 'NIG'
        alpha = 6.1882; beta = -3.8941; delta_nig =  0.1622;
        
        delta = 40;
        L = max(10,delta * sqrt(t * alpha^2 * delta_nig / ((alpha^2 - beta^2)^(3/2))));

        mu = r - q;
        
        c1 = ((beta*delta_nig)/(sqrt(alpha^2 - beta^2)) + mu) * t;
        c2 = t * alpha^2 * delta_nig/ ((alpha^2 - beta^2)^(3/2));
        c4 = 3 * t * alpha^2 * (alpha^2 + 4*beta^2) * delta_nig / ((alpha^2 - beta^2)^(7/2));
        c = [c1, c2, c4];
        % pricing functions
        pricefunc_conv = @(x) double(FFTCONV_E(x, L, alpha_d, cp, model, S0, t, r, q, strike, alpha, beta,0,delta_nig));
        pricefunc_cos = @(x) double(FFTCOS_E(x, L, c, cp, model, S0, t, r, q, strike, alpha, beta, 0,delta_nig));    
end

for j = 1:num
    price(j,1) = n(j);
    price(j,2) = pricefunc_conv(n(j));
    price(j,3) = pricefunc_cos(n(j));
end

figure; plot(price(:,1),price(:,2));
figure; plot(price(:,1), price(:,3));
figure; plot(price(:,1), [price(:,2), price(:,3)]);
figure; plot(price(:,1), log10(price(:,3)));