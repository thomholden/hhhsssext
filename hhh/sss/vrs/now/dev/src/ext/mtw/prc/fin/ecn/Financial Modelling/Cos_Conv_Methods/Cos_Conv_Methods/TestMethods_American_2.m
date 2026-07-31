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



% TestMethods_A2
% Pricing American options using CONV and COS method
% Calculate  speed and deviation from reference value for an American
%    option to a Bermudan changing the number exercise possibilities
% Model : Variance Gamma model
% Method; COS and CONV
clear; clc;
n = 8;                  % N = 2^n
Nex = 10:10:200;        % number of exercise possibilities
num = size(Nex, 2);

S0 = 100;               % spot price of underlying
strike = 110;           % strike price

r = 0.1;                % risk-free rate
t = 1;                  % time to maturity
q = 0;                  % dividend yield

cp = -1;                % call (1) put (-1)

parity = 0;             % use put-call parity (1) or not (0)

% The Variance Gamma model
type = 'VarianceGamma';
sigma = 0.17;                % volatility of the share, per sqrt(unit) time
theta = -0.19;
nu = 0.24;
mu = (r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));

result_p = zeros(2, num);
result_t = result_p;

NAverage = 5;           % calc price NAverage times for cpu time 
d = 6;
% cosine method
Lcos = 13;     

c1 = ((r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2)) + theta) * t;
c2 = (sigma^2 + nu * theta^2) * t;
c4 = (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * t;
c = [c1 c2 c4];
% pricing function for a Bermudan option
pricefunccosb = @(x) FFTCOS_B(n, x, Lcos, c, cp, type, S0, t, r, q, strike, sigma, nu, theta);
% refernce value for an American option
refa_cos =1/21 * ...
    (64* FFTCOS_B(n, 2^(d+3), Lcos, c, cp, type, S0, t, r, q, strike, sigma, nu, theta) ...
    - 56*FFTCOS_B(n, 2^(d+2), Lcos, c, cp, type, S0, t, r, q, strike, sigma, nu, theta) ...
    + 14*FFTCOS_B(n, 2^(d+1), Lcos, c, cp, type, S0, t, r, q, strike, sigma, nu, theta) ...
    - FFTCOS_B(n, 2^d, Lcos, c, cp, type, S0, t, r, q, strike, sigma, nu, theta));

% CONV method
delta = 40;
Lconv = delta * sqrt(t *(sigma^2 + nu*theta^2));    
% pricing function for a Bermudan option
pricefuncconvb = @(x) FFTCONV_B(n, Lconv, 0.5, cp, type, S0, t, r, q, strike, x, sigma, nu, theta);
% reference value for an American option
refa_conv = 1/21 * ...
   (64* FFTCONV_B(n, Lconv, 0.5, cp, type, S0, t, r, q, strike, 2^(d+3), sigma, nu, theta) ...
   - 56*FFTCONV_B(n, Lconv, 0.5, cp, type, S0, t, r, q, strike, 2^(d+2), sigma, nu, theta) ...
   + 14*FFTCONV_B(n, Lconv, 0.5, cp, type, S0, t, r, q, strike, 2^(d+1), sigma, nu, theta) ...
   - FFTCONV_B(n, Lconv, 0.5, cp, type, S0, t, r, q, strike, 2^(d), sigma, nu, theta));

for k = 1:num
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefunccosb(Nex(k));
    end
    result_t(1,k) = (cputime - res_t) / NAverage * 1000;
    result_p(1,k) = (refa_cos - res)/refa_cos;
    
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefuncconvb(Nex(k));
    end
    result_t(2,k) = (cputime - res_t) / NAverage * 1000;
    result_p(2,k) = (refa_conv - res)/refa_conv;
end

% plotting results
YMatrix = [(abs(result_p(1,:))); (abs(result_p(2,:)))];
createfigure_convergence_ab(Nex,YMatrix,'Error','COS','CONV','rel. error (%)');
%plot(n,[log(abs(result_p(1,:))); log(abs(result_p(2,:))); log(abs(result_p(3,:)));log(abs(result_p(4,:)))]);
YMatrix = [(abs(result_t(1,:))); (abs(result_t(2,:)))];
createfigure_convergence_ab(Nex,YMatrix,'CPU Time','COS','CONV','CPU Time (msec)');
figure('Color',[1 1 1]);box('on');hold on; 
plot(result_t(1,:),(abs(result_p(1,:))),'Color',[0 0 0],'Marker','v','LineStyle','--','DisplayName','COS');
plot(result_t(2,:),(abs(result_p(2,:))),'Color',[0 0 0],'Marker','diamond','LineStyle',':','DisplayName','CONV');
% Create xlabel
xlabel('CPU Time');

% Create ylabel
ylabel('rel. error (%)');

% Create title
title('Time / Error Plot');

% Create legend
legend('show');
hold off;
%result_t
%result_p

