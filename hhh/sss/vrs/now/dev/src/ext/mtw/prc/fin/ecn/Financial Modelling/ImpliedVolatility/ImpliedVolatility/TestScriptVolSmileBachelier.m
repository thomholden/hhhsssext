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
S0 = 100;                               % Spot prices
T = [1 2 3 4 5 6 7 8 9 10];             % maturities

r = 0;                                  % discount factors
d = 0;                                  % dividends

K = 80:1:120;                           % Strike range

rows = length(T);
cols = length(K);

FFTopt = ones(rows,cols);               % initializing matrix -> stores the model prices 
ImpliedVol = FFTopt;                    % stores implied volatilities

tit = 'Implied Volatility - Bachelier Model';

legend_base = 'Base scenario';

%% Specify the base model
sigma_base = 20;

for j=1:rows    %wrt time
    FFTopt(j,:) = ncall(S0,K,T(j),r,d,sigma_base,1);
    ImpliedVol(j,:) = blsimpv(S0, K, r, T(j), abs(FFTopt(j,:)));
end

%% Prepare
FFTopt_low = FFTopt;
FFTopt_high = FFTopt;
ImpliedVol_low = ImpliedVol;
ImpliedVol_high = ImpliedVol;


%% Changing sigma
sigma_low = 10;
sigma_high = 30;

for j=1:rows    %wrt time
    FFTopt_low(j,:) = ncall(S0,K,T(j),r,d,sigma_low,1);
    FFTopt_high(j,:) = ncall(S0,K,T(j),r,d,sigma_high,1);
    
    ImpliedVol_low(j,:) = blsimpv(S0, K, r, T(j), abs(FFTopt_low(j,:)));
    ImpliedVol_high(j,:) = blsimpv(S0, K, r, T(j), abs(FFTopt_high(j,:)));
    
end

legend_low  = 'Changing \sigma low';
legend_high = 'Changing \sigma high';

createIV(K,T',ImpliedVol_low, ImpliedVol, ImpliedVol_high, legend_low, legend_base, legend_high,tit);

