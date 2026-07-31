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



% TestMethods_A
% Pricing American options using CONV and COS method
% Calculate price and measure speed and deviation from reference value
%    for an American option for changing the number of grid points
% Model : Variance Gamma model
% Method: COS and CONV

clear; clc;
n = (5:15)';                % N = 2^n grid points
num = size(n, 1);           % length of array n

S0 = 100;                   % spot price of underlying
strike = 110;               % strike price

r = 0.1;                    % risk-free rate
t = 1;                      % term to maturity
q = 0;                      % dividend yield

cp = -1;                     % call (1) or put (-1)

parity = 0;                 % use put-call parity (1) or not (0)

% The Variance Gamma model
model = 'VarianceGamma';
sigma = 0.17;                % volatility of the share, per sqrt(unit) time
theta = -0.19;
nu = 0.24;
mu = (r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));

result_p = zeros(2, size(n,1));
result_t = result_p;

NAverage = 10;                      % calc price NAverage times for cpu time
d = 6;                              % base for Richardson extrapolation

% COS method
Lcos = 13;     

c1 = ((r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2)) + theta) * t;
c2 = (sigma^2 + nu * theta^2) * t;
c4 = (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * t;
c = [c1 c2 c4];
% pricing function for American option using Richardson extrapolation
pricefunccos = @(x) 1/21 * ...
    (64* FFTCOS_B(x, 2^(d+3), Lcos, c, cp, model, S0, t, r, q, strike, sigma, nu, theta) ...
    - 56*FFTCOS_B(x, 2^(d+2), Lcos, c, cp, model, S0, t, r, q, strike, sigma, nu, theta) ...
    + 14*FFTCOS_B(x, 2^(d+1), Lcos, c, cp, model, S0, t, r, q, strike, sigma, nu, theta) ...
    - FFTCOS_B(x, 2^d, Lcos, c, cp, model, S0, t, r, q, strike, sigma, nu, theta));

refval = pricefunccos(6);                   % Reference Value

% CONV method
delta = 40;                                         % delta parameter
Lconv = delta * sqrt(t *(sigma^2 + nu*theta^2));    % L rule of thumb
% pricing function for American option using Richardson extrapolation
pricefuncconv = @(x) 1/21 * ...
    (64* FFTCONV_B(x, Lconv, 0.5, cp, model, S0, t, r, q, strike, 2^(d+3), sigma, nu, theta) ...
    - 56*FFTCONV_B(x, Lconv, 0.5, cp, model, S0, t, r, q, strike, 2^(d+2), sigma, nu, theta) ...
    + 14*FFTCONV_B(x, Lconv, 0.5, cp, model, S0, t, r, q, strike, 2^(d+1), sigma, nu, theta) ...
    - FFTCONV_B(x, Lconv, 0.5, cp, model, S0, t, r, q, strike, 2^(d+1), sigma, nu, theta));

for k = 1:size(n)
    % COS method
    res_p = 0;            % result price    
    res_t = cputime;      % result time
    for l = 1:NAverage
        res_p = pricefunccos(n(k));   % pricing
    end
    result_t(1,k) = (cputime - res_t) / NAverage * 1000; % speed
    result_p(1,k) = (refval - res_p)/refval*10000;       % dev from ref
    % CONV method
    res_p = 0;            % result price
    res_t = cputime;      % result time
    for l = 1:NAverage
        res_p = pricefuncconv(n(k));    % pricing
    end
    result_t(2,k) = (cputime - res_t) / NAverage * 1000; % speed
    result_p(2,k) = (refval - res_p)/refval*10000;       % dev from ref
end

% plotting
YMatrix = [log(abs(result_p(1,:))); log(abs(result_p(2,:)))];
createfigure_convergence_b(n,YMatrix,'Error','COS','CONV');
%plot(n,[log(abs(result_p(1,:))); log(abs(result_p(2,:))); log(abs(result_p(3,:)));log(abs(result_p(4,:)))]);
YMatrix = [log(abs(result_t(1,:))); log(abs(result_t(2,:)))];
createfigure_convergence_b(n,YMatrix,'CPU Time','COS','CONV');
figure('Color',[1 1 1]);box('on');hold on; 
plot(result_t(1,:),log(abs(result_p(1,:))),'Color',[0 0 0],'Marker','v','LineStyle','--','DisplayName','COS');
plot(result_t(2,:),log(abs(result_p(2,:))),'Color',[0 0 0],'Marker','diamond','LineStyle',':','DisplayName','CONV');
% Create xlabel
xlabel('CPU Time');

% Create ylabel
ylabel('log(rel. error)');

% Create title
title('Time / Error Plot');

% Create legend
legend('show');
hold off;
%result_t
%result_p

