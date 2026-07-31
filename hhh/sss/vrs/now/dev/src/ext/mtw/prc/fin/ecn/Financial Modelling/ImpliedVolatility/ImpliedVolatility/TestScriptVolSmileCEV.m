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
S0 = 100;                                   % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];      % maturities

r = 0;                      % discount factors
d = 0;                              % dividends

K = 80:1:120;                           % Strike range

rows = length(T);
cols = length(K);

FFTopt = ones(rows,cols);                   % initializing matrix -> stores the model prices 
ImpliedVol = FFTopt;                        % stores implied volatilities

tit = 'Implied Volatility - CEV Model';

legend_base = 'Base scenario';

%% Specify the base model
beta_base = 0.5;
sigma_base = 0.2 * S0^(1-beta_base);

% cf (characteristic function) for the heston model

for j=1:rows    %wrt time
    FFTopt(j,:) = callacev2(S0,K,T(j),beta_base,sigma_base,r);
    ImpliedVol(j,:) = blsimpv(S0, K, r, T(j), FFTopt(j,:));
end

%% Prepare
FFTopt_low = FFTopt;
FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol;
ImpliedVol_high = ImpliedVol;

%% Changing beta
beta_low = 0.4;
beta_high = 0.6;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = callacev2(S0,K,T(j),beta_low,0.2*S0^(1-beta_low),r);
    FFTopt_high(j,:) = callacev2(S0,K,T(j),beta_high,0.2*S0^(1-beta_high),r);

    ImpliedVol_low(j,:) = blsimpv(S0, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S0, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing \beta low';
legend_high = 'Changing \beta high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);


%% Changing sigma
sigma_low = 0.15 * S0^(1-beta_base);
sigma_high = 0.25 * S0^(1-beta_base);

for j=1:rows    %wrt time
    FFTopt_low(j,:) = callacev2(S0,K,T(j),beta_base,sigma_low,r);
    FFTopt_high(j,:) = callacev2(S0,K,T(j),beta_base,sigma_high,r);
    
    ImpliedVol_low(j,:) = blsimpv(S0, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S0, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing \sigma low';
legend_high = 'Changing \sigma high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

