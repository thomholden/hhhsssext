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
S0 = 100;                        % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];      % maturities

r = 0;                           % zero rate
d = 0;                           % dividends

K = 80:1:120;                    % Strike range

rows = length(T);
cols = length(K);

FFTopt = ones(rows,cols);        % stores the model prices 
ImpliedVol = FFTopt;             % stores implied volatilities

tit = 'Implied Volatility - DD Model';

legend_base = 'Base scenario';

%% Specify the base model
beta_base = 10;
sigma_base = 0.2;

% cf (characteristic function) for the heston model

for j=1:rows    %wrt time
    FFTopt(j,:) = blsprice(S0+beta_base, K+beta_base, 0, T(j), sigma_base,0);
    ImpliedVol(j,:) = blsimpv(S, K, r, T(j), FFTopt(j,:));
end

%% Prepare
FFTopt_low = FFTopt; FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol; ImpliedVol_high = ImpliedVol;

%% Changing vInst
beta_low = 5;
beta_high = 20;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = blsprice(S0+beta_low, K+beta_low, 0, T(j), sigma_base,0);
    FFTopt_high(j,:) = blsprice(S0+beta_high, K+beta_high, 0, T(j), sigma_base,0);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end
legend_low = 'Changing a low';
legend_high = 'Changing a high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);


%% Changing vLong
sigma_low = 0.1;
sigma_high = 0.3;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = blsprice(S0+beta_base, K+beta_base, 0, T(j), sigma_low,0);
    FFTopt_high(j,:) = blsprice(S0+beta_base, K+beta_base, 0, T(j), sigma_high,0);

    ImpliedVol_low(j,:) = blsimpv(S, K, r, T(j), FFTopt_low(j,:));
    ImpliedVol_high(j,:) = blsimpv(S, K, r, T(j), FFTopt_high(j,:));
    
end

legend_low  = 'Changing \sigma low';
legend_high = 'Changing \sigma high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

