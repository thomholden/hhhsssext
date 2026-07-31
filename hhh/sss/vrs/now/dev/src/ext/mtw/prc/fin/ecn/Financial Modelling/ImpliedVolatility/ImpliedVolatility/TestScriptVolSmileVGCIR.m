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

% Parameters
S = 100;                        % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];     % maturities

r = 0.03;                       % zero rate
d = 0;                          % dividends

K = 80:1:120;                   % Strike range

rows = length(T);
cols = length(K);

FFTopt = ones(rows,cols);       % stores the model prices 
ImpliedVol = FFTopt;            % stores implied volatilities

tit = 'Implied Volatility - Variance Model VG CIR';

legend_base = 'Base scenario';

%% Specify the base model           

C = 11.9896;
G = 25.8523;
M = 35.5344;

kappa = 0.5391;
eta = 1.5746;
lambda = 1.8772;

for j=1:rows    %wrt time
    FFTopt(j,:) = CallPricingFFT('VarianceGammaCIR',S,K,T(j),r,d,C,G,M,kappa,eta,lambda);
    ImpliedVol(j,:) = blsimpv(S, K, r, T(j), FFTopt(j,:));
end

%% Prepare
FFTopt_low = FFTopt;
FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol;
ImpliedVol_high = ImpliedVol;

%% Changing lambda
lambda_low = 1;
lambda_high = 3;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('VarianceGammaCIR',S,K,T(j),r,d,C,G,M,kappa,eta,lambda_low);
    FFTopt_high(j,:) = CallPricingFFT('VarianceGammaCIR',S,K,T(j),r,d,C,G,M,kappa,eta,lambda_high);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \lambda low';
legend_high = 'Changing \lambda high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);

%% Changing kappa
kappa_low = .25;
kappa_high = 1;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('VarianceGammaCIR',S,K,T(j),r,d,C,G,M,kappa_low,eta,lambda);
    FFTopt_high(j,:) = CallPricingFFT('VarianceGammaCIR',S,K,T(j),r,d,C,G,M,kappa_high,eta,lambda);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \kappa low';
legend_high = 'Changing \kappa high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);


%% Changing eta
eta_low = 1;
eta_high = 2;

for j=1:rows    %wrt time
    FFTopt_low(j,:)  = CallPricingFFT('VarianceGammaCIR',S,K,T(j),r,d,C,G,M,kappa,eta_low,lambda);
    FFTopt_high(j,:) = CallPricingFFT('VarianceGammaCIR',S,K,T(j),r,d,C,G,M,kappa,eta_high,lambda);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \eta low';
legend_high = 'Changing \eta high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high, tit);

