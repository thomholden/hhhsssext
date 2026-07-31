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
S = 100;                            % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];         % maturities

r = 0.03;                           % zero rate
d = 0;                              % dividends

K = 80:1:120;                       % Strike range

rows = length(T);
cols = length(K);

FFTopt = ones(rows,cols);           % stores the model prices 
ImpliedVol = FFTopt;                % stores implied volatilities

tit = 'Implied Volatility - Normal Inverse Gaussian (NIG)';

legend_base = 'Base scenario';

%% Specify the base model 
alpha = 6.1882;                     % alpha parameter NIG
beta = 0;                           % beta parameter NIG
delta = 0.1622;                     % delta parameter NIG
mu = 0;                             % mu parameter NIG

for j=1:rows    %wrt time
    FFTopt(j,:) = CallPricingFFT('NIG',S,K,T(j),r,d,alpha,beta,mu,delta);
    ImpliedVol(j,:) = blsimpv(S, K, r, T(j), FFTopt(j,:));
end

%% Prepare
FFTopt_low = FFTopt; FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol; ImpliedVol_high = ImpliedVol;

%% Changing alpha
alpha_low = 6;
alpha_high = 6.5;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('NIG',S,K,T(j),r,d,alpha_low,beta,mu,delta);
    FFTopt_high(j,:) = CallPricingFFT('NIG',S,K,T(j),r,d,alpha_high,beta,mu,delta);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \alpha low';
legend_high = 'Changing \alpha high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);


%% Changing beta
beta_low = -2;
beta_high = 2;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('NIG',S,K,T(j),r,d,alpha,beta_low,mu,delta);
    FFTopt_high(j,:) = CallPricingFFT('NIG',S,K,T(j),r,d,alpha,beta_high,mu,delta);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \beta low';
legend_high = 'Changing \beta high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);

%% Changing delta
delta_low = 0.15;
delta_high = 0.2;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('NIG',S,K,T(j),r,d,alpha,beta,mu,delta_low);
    FFTopt_high(j,:) = CallPricingFFT('NIG',S,K,T(j),r,d,alpha,beta,mu,delta_high);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \delta low';
legend_high = 'Changing \delta high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);
