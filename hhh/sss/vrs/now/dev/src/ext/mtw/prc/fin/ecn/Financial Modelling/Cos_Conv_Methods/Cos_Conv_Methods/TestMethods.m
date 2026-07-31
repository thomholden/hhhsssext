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



clear; clc;
n = (5:15)';    % choose number of grid points (applied to Bermudan only), N = 2^n
num = size(n, 1);

S0 = 100;                   % price of underlying
strike = 80;      % strike price

r = 0.1;                    % annual risk-free rate (cc)
t = 5;                    % term to maturity
q = 0;                      % annual dividend yield (cc)

cp = 1;                     % choice of call (=1) or put (=-1)

parity = 0;     % choose to use put-call parity (yes = 1, no = 0), applies to call pricing only

% The Variance Gamma model
type = 'VarianceGamma';
sigma = 0.17;                % volatility of the share, per sqrt(unit) time
theta = -0.19;
nu = 0.24;
mu = (r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));

% cosine method
Lcos = 10;     

c1 = (mu + theta) * t;
c2 = (sigma^2 + nu * theta^2) * t;
c4 = 3 * (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * t;
c = [c1, c2, c4];
pricefunccos = @(x) double(FFTCOS_E(x, Lcos, c, cp, type, S0, t, r, q, strike, sigma, nu, theta));
       

% conv method
delta = 40;
Lconv = delta * sqrt(t *(sigma^2 + nu*theta^2));
pricefuncconv = @(x) double(FFTCONV_E(x, Lconv, 0.5, cp, type, S0, t, r, q, strike, sigma, nu, theta));


% lewis
pricefunclewis = @(x) double(LewisCallPricingFFT('VarianceGamma',x,S0,strike,t,r,q,sigma,nu,theta));

% carr-madan
pricefunccm = @(x) CallPricingFFT('VarianceGamma',x,S0,strike,t,r,q,sigma,nu,theta);

result_p = zeros(4, size(n,1));
result_t = result_p;

NAverage = 50;
referenceValue = pricefunccos(20);
for k = 1:size(n)
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefunccos(n(k));
    end
    result_t(1,k) = (cputime - res_t) / NAverage * 1000;
    result_p(1,k) = (referenceValue - res)/referenceValue*10000;
    
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefuncconv(n(k));
    end
    result_t(2,k) = (cputime - res_t) / NAverage * 1000;
    result_p(2,k) = (referenceValue - res)/referenceValue*10000;
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefunclewis(n(k));
    end
    result_t(3,k) = (cputime - res_t) / NAverage * 1000;
    result_p(3,k) = (referenceValue - res)/referenceValue*10000;
    res = 0;
    res_t = cputime;
    for l = 1:NAverage
        res = pricefunccm(n(k));
    end
    result_t(4,k) = (cputime - res_t) / NAverage * 1000;
    result_p(4,k) = (referenceValue - res)/referenceValue*10000;
end

YMatrix = [log(abs(result_p(1,:))); log(abs(result_p(2,:))); log(abs(result_p(3,:)));log(abs(result_p(4,:)))];
createfigure_convergence(n,YMatrix,'Error','COS','CONV','Lewis','CM');
%plot(n,[log(abs(result_p(1,:))); log(abs(result_p(2,:))); log(abs(result_p(3,:)));log(abs(result_p(4,:)))]);
YMatrix = [log(abs(result_t(1,:))); log(abs(result_t(2,:))); log(abs(result_t(3,:)));log(abs(result_t(4,:)))];
createfigure_convergence(n,YMatrix,'CPU Time','COS','CONV','Lewis','CM');
figure('Color',[1 1 1]);box('on');hold on; 
plot(result_t(1,:),log(abs(result_p(1,:))),'Color',[0 0 0],'Marker','v','LineStyle','--','DisplayName','COS');
plot(result_t(2,:),log(abs(result_p(2,:))),'Color',[0 0 0],'Marker','diamond','LineStyle',':','DisplayName','CONV');
plot(result_t(3,:),log(abs(result_p(3,:))),'Color',[0 0 0],'Marker','square','LineStyle','--','DisplayName','Lewis');
plot(result_t(4,:),log(abs(result_p(4,:))),'Color',[0 0 0],'Marker','o','DisplayName','CM');
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

