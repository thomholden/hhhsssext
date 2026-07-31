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

%% Parameters
S = 100;                         % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];      % maturities

r = 0.03;                        % discount factors
d = 0;                           % dividends

K = 80:1:120;                    % Strike range

rows = length(T);
cols = length(K);

FFTopt = ones(rows,cols);        % stores the model prices 
ImpliedVol = FFTopt;             % stores implied volatilities

tit = 'Implied Volatility - Variance Model';

legend_base = 'Base scenario';

%% Specify the base model 
sigma = .075;               % VG parameter
nu = .2;                    % VG parameter
theta = 0;                  % VG parameter

for j=1:rows    %wrt time
    FFTopt(j,:) = CallPricingFFT('VarianceGamma',S,K,T(j),r,d,sigma,nu,theta);
    ImpliedVol(j,:) = blsimpv(S, K, r, T(j), FFTopt(j,:));
end

%% Prepare
FFTopt_low = FFTopt; FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol; ImpliedVol_high = ImpliedVol;

%% Changing sigma
sigma_low = .05;
sigma_high = .1;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('VarianceGamma',S,K,T(j),r,d,sigma_low,nu,theta);
    FFTopt_high(j,:) = CallPricingFFT('VarianceGamma',S,K,T(j),r,d,sigma_high,nu,theta);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \sigma low';
legend_high = 'Changing \sigma high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);


%% Changing nu
nu_low = .1;
nu_high = .3;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('VarianceGamma',S,K,T(j),r,d,sigma,nu_low,theta);
    FFTopt_high(j,:) = CallPricingFFT('VarianceGamma',S,K,T(j),r,d,sigma,nu_high,theta);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \nu low';
legend_high = 'Changing \nu high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);

%% Changing theta
theta_low = -.05;
theta_high = .05;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('VarianceGamma',S,K,T(j),r,d,sigma,nu,theta_low);
    FFTopt_high(j,:) = CallPricingFFT('VarianceGamma',S,K,T(j),r,d,sigma,nu,theta_high);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \theta low';
legend_high = 'Changing \theta high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);

