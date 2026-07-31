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



% TestMethods_B
% Pricing American options using CONV and COS method
% Calculate  speed and deviation from reference value for a Bermudan
%    option dependent on the size of the grid
% Model : Variance Gamma and Black Scholes model
% Method; COS and CONV

clear; clc;
n = (9:10)';                % N = 2^n grid points
num = size(n, 1);
Nex = 10;                   % 10 exercise opportunities

S0 = 100;                   % spot price of underlying
strike = 110;               % strike price

r = 0.1;                    % risk-free rate
t = 1;                      % time to maturity
q = 0;                      % dividend yield

cp = -1;                    % call (1) put (-1)

% The Variance Gamma model
% model = 'VarianceGamma';
% sigma = 0.17;                % volatility of the share, per sqrt(unit) time
% theta = -0.19;
% nu = 0.24;
% mu = (r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));
% c1 = ((r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2)) + theta) * t;
% c2 = (sigma^2 + nu * theta^2) * t;
% c4 = 3 * (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * t;

model = 'BlackScholes';
sigma = 0.2;
c1 = (r - q - 0.5 * sigma^2) * t;
c2 = sigma^2 * t;
c4 = 0.0;

% COS method
Lcos = 13;     
c = [c1, c2, c4];
%pricing function
%pricefunccos = @(x) double(FFTCOS_B(x, Nex, Lcos, c, cp, model, S0, t, r, q, strike, sigma, nu, theta));     
pricefunccos = @(x) double(FFTCOS_B(x, Nex, Lcos, c, cp, model, S0, t, r, q, strike, sigma));

% CONV method
delta = 40;
%Lconv = delta * sqrt(t *(sigma^2 + nu*theta^2));
Lconv = delta * sqrt(t) * sigma;
%pricing function
%pricefuncconv = @(x) double(FFTCONV_B(x, Lconv, 0.5, cp, type, S0, t, r, q, strike, Nex, sigma, nu, theta));
pricefuncconv = @(x) double(FFTCONV_B(x, Lconv, 0.5, cp, type, S0, t, r, q, strike, Nex, sigma));

result_p = zeros(2, size(n,1));
result_t = result_p;

NAverage = 1;
refval = pricefunccos(9);
for k = 1:size(n)
    res_p = 0;
    res_t = cputime;
    for l = 1:NAverage
        res_p = pricefunccos(n(k));
    end
    result_t(1,k) = (cputime - res_t) / NAverage * 1000;
    result_p(1,k) = (refval - res_p)/refval*10000;
    
    res_p = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefuncconv(n(k));
    end
    result_t(2,k) = (cputime - res_t) / NAverage * 1000;
    result_p(2,k) = (refval - res_p)/refval*10000;
end

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

