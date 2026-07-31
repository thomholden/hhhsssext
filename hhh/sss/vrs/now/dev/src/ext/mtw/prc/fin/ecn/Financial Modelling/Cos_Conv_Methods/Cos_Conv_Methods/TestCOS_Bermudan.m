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
Nex = 10;

S0 = 100;                   % price of underlying
strike = (80:10:120)';      % strike price

r = 0.1;                    % annual risk-free rate (cc)
t = 1;                    % time to maturity
q = 0;                      % annual dividend yield (cc)

cp = -1;                     % choice of call (=1) or put (=-1)

% % Black Scholes
% type = 'BlackScholes';
% sigma = 0.2;
% c1 = (r - q - 0.5 * sigma^2) * t;
% c2 = sigma^2 * t;
% c4 = 0.0;

% % The Variance Gamma model
% type = 'VarianceGamma';
% sigma = 0.17;                % volatility of the share, per sqrt(unit) time
% theta = -0.19;
% nu = 0.24;
% mu = (r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2));
% c1 = ((r - q + 1/nu * log(1 - theta * nu - 0.5 * nu * sigma^2)) + theta) * t;
% c2 = (sigma^2 + nu * theta^2) * t;
% c4 = 3 * (sigma^4 * nu + 2 * theta^4 * nu^3 + 4 * (sigma * theta * nu)^2) * t;

% The CGMY model
type = 'CGMY';
C = 1;                
G = 5;
M = 5;
Y = 1.5;
c1 = ( (r - q) + C*gamma(1-Y)*(M^(Y-1)-G^(Y-1)) )*t;
c2 = C*gamma(2-Y)*(M^(Y-2)+G^(Y-2))*t;
c4 = 3 + C*gamma(4-Y)*(M^(Y-4)+G^(Y-4))*t/(C*gamma(2-Y)*(M^(Y-2)+G^(Y-2)))^2;

Lcos = 13;     
c = [c1, c2, c4];

% cosine method single strike
%pricefunccos1 = @(x,strike) FFTCOS_B(x, Nex, Lcos, c, cp, type, S0, t, r, q, strike, sigma);     
%pricefunccos1 = @(x,strike) FFTCOS_B(x, Nex, Lcos, c, cp, type, S0, t, r, q, strike, sigma,nu,theta);
pricefunccos1 = @(x,strike) FFTCOS_B(x, Nex, Lcos, c, cp, type, S0, t, r, q, strike, C,G,M,Y);

nrStrikes = length(strike);
referenceValue1 = zeros(nrStrikes,1);
for i = 1:nrStrikes
    referenceValue1(i) = pricefunccos1(9,strike(i));
end
display(referenceValue1)


% cosine method multiple strikes
%pricefunccos2 = @(x) FFTCOS_B_2(x, Nex, Lcos, c, cp, type, S0, t, r, q, strike, sigma);
%pricefunccos2 = @(x) FFTCOS_B_2(x, Nex, Lcos, c, cp, type, S0, t, r, q, strike, sigma, nu, theta);
pricefunccos2 = @(x) FFTCOS_B_2(x, Nex, Lcos, c, cp, type, S0, t, r, q, strike, C,G,M,Y);

referenceValue2 = pricefunccos2(9);
display(referenceValue2)

